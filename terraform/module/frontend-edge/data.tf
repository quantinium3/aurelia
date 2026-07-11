data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

data "aws_resourcegroupstaggingapi_resources" "frontend_alb" {
  resource_type_filters = ["elasticloadbalancing:loadbalancer"]

  tag_filter {
    key    = "elbv2.k8s.aws/cluster"
    values = [var.cluster_name]
  }
}

data "aws_lb" "frontend" {
  arn = data.aws_resourcegroupstaggingapi_resources.frontend_alb.resource_tag_mapping_list[0].resource_arn
}
