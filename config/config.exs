use Mix.Config

# Configure Mix tasks and generators
config :bug_example,
  ecto_repos: [BugExample.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure your database
config :bug_example, BugExample.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_NAME"),
  port: System.get_env("DB_PORT"),
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
