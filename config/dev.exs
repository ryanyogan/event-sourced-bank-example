import Config

config :bank, Bank.ProjectionStoreRepo,
  database: "bank_projection_store_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :bank, Bank.EventStoreRepo,
  database: "bank_event_store_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
