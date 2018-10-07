use Mix.Config

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: System.get_env("DB_USERNAME"),
  database: "fc_identity_eventstore_dev",
  hostname: "localhost",
  pool_size: 10

config :fc_identity, FCIdentity.SimpleStore, FCIdentity.DynamoStore