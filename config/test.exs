use Mix.Config

# Configure your database
config :pontinho, Pontinho.Repo,
  username: "postgres",
  password: "postgres",
  database: "pontinho_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :pontinho,
  deck_shuffle_times: 0

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pontinho_web, PontinhoWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
