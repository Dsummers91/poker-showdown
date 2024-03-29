defmodule ShowdownWeb.Router do
  use ShowdownWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShowdownWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: ShowdownWeb.Schema

    forward "/", Absinthe.Plug,
      schema: ShowdownWeb.Schema

  end

  # Other scopes may use custom stacks.
  # scope "/api", ShowdownWeb do
  #   pipe_through :api
  # end
end
