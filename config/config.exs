# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :game, GameWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tP2UtdqHFCxhwEaP30wE1KcSTUw3wMlvNI7FC2i2oxhnlMO1TWfI4yLcMwjbuxy8",
  render_errors: [view: GameWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Game.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "2hbvutWlGq6CSJov2umfqmO64MnaxFGT"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
