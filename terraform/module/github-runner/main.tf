data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "runner" {
  name        = "${var.name}-runner"
  description = "GitHub Actions self-hosted runner - egress only"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_iam_role" "runner" {
  name = "${var.name}-runner"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.runner.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "runner" {
  name = "${var.name}-runner"
  role = aws_iam_role.runner.name
}

resource "aws_instance" "runner" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.runner.id]
  iam_instance_profile   = aws_iam_instance_profile.runner.name

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail
    dnf install -y tar gzip libicu jq unzip
    curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip
    unzip -q /tmp/awscliv2.zip -d /tmp && /tmp/aws/install
    curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
    chmod +x /usr/local/bin/kubectl
    useradd -m runner || true
    cd /home/runner
    mkdir -p actions-runner && cd actions-runner
    curl -fsSL -o runner.tar.gz "https://github.com/actions/runner/releases/download/v${var.runner_version}/actions-runner-linux-x64-${var.runner_version}.tar.gz"
    tar xzf runner.tar.gz && rm runner.tar.gz
    chown -R runner:runner /home/runner/actions-runner
    ./bin/installdependencies.sh
    sudo -u runner ./config.sh --unattended --replace \
      --url ${var.github_repo_url} \
      --token ${var.registration_token} \
      --name ${var.name} \
      --labels ${var.env_label} \
      --work _work
    ./svc.sh install runner
    ./svc.sh start
  EOF

  lifecycle {
    ignore_changes = [user_data, ami]
  }

  tags = merge(var.tags, { Name = "${var.name}-runner" })
}
