import Config

config :bank,
  ecto_repos: [Bank.EventStoreRepo, Bank.ProjectionStoreRepo]

import_config "#{config_env()}.exs"
