defmodule Showdown.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Showdown.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ShowdownWeb.Endpoint, []),
      supervisor(Absinthe.Subscription, [ShowdownWeb.Endpoint]), # add this line


      supervisor(Game.Server, []),
      #TODO: make this inside of scheduler instead of genserver
      supervisor(Game.GameCreator, []),
      worker(Showdown.Scheduler, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Showdown.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ShowdownWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
