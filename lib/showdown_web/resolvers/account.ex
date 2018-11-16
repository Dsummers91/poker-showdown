defmodule ShowdownWeb.Resolvers.Account do

  def list_users(_parent, _args, _resolution) do
    {:ok, Showdown.Accounts.list_users()}
  end

  def get_user(_parent, args, _resolution) do
    {:ok, Showdown.Accounts.get_user(args)}
  end

  def create_user(_parent, args, _resolution) do
    Showdown.Accounts.create_user(args)
  end

  def top_up_balance(_parent, args, _resolution) do
    Showdown.Accounts.top_up_balance(args)
  end

  def update_user(_parent, args, _resolution) do
    Showdown.Accounts.update_user(args)
  end

  def make_bet(_parent, args, _resolution) do
    Showdown.Accounts.make_bet(args)
  end
end
