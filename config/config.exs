# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :photo_flow_example, ecto_repos: [PhotoFlowExample.Repo]

# Configures the endpoint
config :photo_flow_example, PhotoFlowExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "T45gz8p93MoIjvmTMvpigJrkF1WumnNtISZ/OKo2oibFR1IYAChfoHSk+tCi2+Rw",
  render_errors: [view: PhotoFlowExampleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhotoFlowExample.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines, haml: PhoenixHaml.Engine

config :arc, storage: Arc.Storage.Local

config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 60 * 4,
                                 cleanup_interval_ms: 60_000 * 10]}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
