# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :pontinho,
  ecto_repos: [Pontinho.Repo]

config :pontinho,
  cards_shuffle_times: 10

config :pontinho_web,
  ecto_repos: [Pontinho.Repo],
  generators: [context_app: :pontinho, binary_id: true]

# Configures the endpoint
config :pontinho_web, PontinhoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bGsPqTLDlmSYVdY1KEwBF3uumEV5SzcSjgYtrdzMJ3P+iyH6OJ8PMjVofVRul+B4",
  render_errors: [view: PontinhoWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: PontinhoWeb.PubSub,
  live_view: [signing_salt: "T+0UVMpl"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
