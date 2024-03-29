defmodule Showdown.Mixfile do
  use Mix.Project

  def project do
    [
      app: :showdown,
      version: "0.0.2",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: [
        main: "Showdown", # The main page in the docs
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Showdown.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:absinthe, "~> 1.4.0"},
      {:absinthe_phoenix, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4.0"},
      {:cowboy, "~> 1.0"},
      {:dialyxir, "1.0.0-rc.3", only: [:dev], runtime: false},
      {:ethereumex, "~> 0.4.0"},
      {:ex_doc, "~> 0.19.0", only: :dev, runtime: false},
      {:exth_crypto, "~> 0.1.6"},
      {:exw3, "~> 0.4.0"},
      {:gettext, "~> 0.11"},
      {:phoenix, "~> 1.3.4"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: [:dev, :zhen]},
      {:phoenix_pubsub, "~> 1.0"},
      {:plug, "~> 1.6.0"},
      {:poison, "~> 3.0", override: true},
      {:postgrex, ">= 0.0.0"},
      {:quantum, "~> 2.3"},
      {:timex, "~> 3.0"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
