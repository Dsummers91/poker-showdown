defmodule ShowdownWeb.Schema do
  use Absinthe.Schema
  import_types ShowdownWeb.Schema.Accounts
  import_types ShowdownWeb.Schema.Games

  alias ShowdownWeb.Resolvers

  input_object :update_user_params do
    field :address, non_null(:string)
  end

  input_object :signed_bet_tx do
    field :game_id, non_null(:id)
    field :winner, non_null(:string)
    field :amount, non_null(:string)
    field :signed_tx, non_null(:string)
    #field :none, non_null(:integer)
  end

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Resolvers.Account.list_users/3
    end

    @desc "Get all games"
    field :games, list_of(:game) do
      resolve &Resolvers.Casino.list_games/3
    end

    @desc "Get a specific game"
    field :game, :game do
      arg :id, non_null(:id)
      resolve &Resolvers.Casino.find_game/3
    end

    @desc "Get all active games"
    field :active_games, list_of(:game) do
      resolve &Resolvers.Casino.list_active_games/3
    end
  end

  mutation do
    @desc "Create a new user"
    field :create_user, type: :user do 
      arg :address, non_null(:string)
      resolve &Resolvers.Account.create_user/3
    end

    @desc "Update an existing user"
    field :update_user, type: :user do
      arg :id, non_null(:integer)
      arg :user, :update_user_params
      resolve &Resolvers.Account.update_user/3
    end

    @desc "Creates a bet for the user"
    field :make_bet, type: :user do
      arg :address, :string
      arg :bet, :signed_bet_tx
      resolve &Resolvers.Account.make_bet/3
    end
  end

  subscription do
    field :game_created, :game do

      config fn _, _ ->
        {:ok, topic: "game"}
      end
    end
  end
end


