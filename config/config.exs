# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :showdown,
  ecto_repos: [Showdown.Repo]

config :showdown,
  env: Mix.env

# Configures the endpoint
config :showdown, ShowdownWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5ltfmDsG5yDB9EKwQBgpRbV2uVRfYA1e/HmTny0Fw/biTl/0AVbPA4X2SnAsQG/3",
  render_errors: [view: ShowdownWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Showdown.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :ethereumex,
  #url: "http://localhost:8545"
  url: "https://kovan.infura.io/v3/9d8f78bda44d422195fe01c95742aa1a"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
