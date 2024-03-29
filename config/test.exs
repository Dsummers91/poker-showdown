use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :showdown, ShowdownWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger,
  backends: [:console],
    compile_time_purge_level: :warn

# Configure your database
config :showdown, Showdown.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "showdown_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
