resource "snowflake_warehouse" "playground_wh" {
  name           = "PLAYGROUND_WH"
  warehouse_size = "X-SMALL"
  auto_suspend   = 60
  auto_resume    = "true"
}

resource "snowflake_database" "playground_db" {
  name         = "PLAYGROUND_DB"
  is_transient = true
}

resource "snowflake_schema" "playground_schema" {
  name         = "PLAYGROUND_SCHEMA"
  database     = snowflake_database.playground_db.name
  is_transient = "true"
}
