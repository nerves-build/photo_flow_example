use Mix.Config

config :photo_flow_example, PhotoFlowExampleWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :photo_flow_example, PhotoFlowExampleWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/photo_flow_example_web/views/.*(ex)$},
      ~r{lib/photo_flow_example_web/templates/.*(eex|haml)$}
    ]
  ]

config :logger, :console, level: :info, format: "[$level] $message\n"

config :photo_flow_example, PhotoFlowExample,
  scanned_folder: "SOURCE_DIR",
  image_destination: "DESTINATION_DIR"

config :phoenix, :stacktrace_depth, 20

config :geonames,
  username: "GEONAMES_USER_NAME",
  language: "en"

config :photo_flow_example, PhotoFlowExample.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "postgres",
  password: "postgres",
  database: "photo_flow_example_dev",
  hostname: "localhost",
  port: "8889",
  pool_size: 10
