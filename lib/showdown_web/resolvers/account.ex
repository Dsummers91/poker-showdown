defmodule ShowdownWeb.Resolvers.Account do

    def list_users(_parent, _args, _resolution) do
          {:ok, Showdown.Accounts.list_users()}
        end

end
