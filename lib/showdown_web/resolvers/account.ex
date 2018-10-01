defmodule ShowdownWeb.Resolvers.Account do

  def list_users(_parent, _args, _resolution) do
    {:ok, Showdown.Accounts.list_users()}
  end

  def create_user(_parent, args, _resolution) do
    Showdown.Accounts.create_user(args)
  end

  def update_user(_parent, args, _resolution) do
    Showdown.Accounts.update_user(args)
  end
end
