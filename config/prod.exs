import Config

config :bank, Bank.ProjectionStoreRepo,
  database: "bank_projection_store_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :bank, Bank.EventStoreRepo,
  database: "bank_event_store_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"
