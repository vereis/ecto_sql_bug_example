use Mix.Config

# Configure your database
config :bug_example, BugExample.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_NAME"),
  port: System.get_env("DB_PORT"),
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
