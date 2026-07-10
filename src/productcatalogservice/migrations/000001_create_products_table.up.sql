CREATE TABLE IF NOT EXISTS products (
    id                       TEXT PRIMARY KEY,
    name                     TEXT NOT NULL,
    description              TEXT NOT NULL,
    picture                  TEXT NOT NULL,
    price_usd_currency_code  TEXT NOT NULL,
    price_usd_units          BIGINT NOT NULL,
    price_usd_nanos          INTEGER NOT NULL,
    categories               TEXT NOT NULL
);
