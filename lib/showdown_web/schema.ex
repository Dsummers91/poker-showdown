defmodule ShowdownWeb.Schema do
  use Absinthe.Schema
  import_types ShowdownWeb.Schema.Accounts
  import_types ShowdownWeb.Schema.Games

  alias ShowdownWeb.Resolvers

  input_object :update_user_params do
    field :address, non_null(:string)
  end

  input_object :add_bet_params do
    field :game_id, non_null(:id)
    @desc "player being betted on"
    field :player_name, non_null(:string)
    field :user_address, non_null(:string)
    field :bet_amount, non_null(:integer)
  end

  input_object :signed_bet_tx do
    field :game_id, non_null(:id)
    field :winner, non_null(:string)
    field :amount, non_null(:integer)
    #field :signed_tx, non_null(:string)
    #field :nonce, non_null(:integer)
  end

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Resolvers.Account.list_users/3
    end

    @desc "Get a user"
    field :user, :user do
      arg :address, non_null(:string)
      resolve &Resolvers.Account.get_user/3
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
    #This should be admin only
    @desc "Add deposit to user"
    field :deposit, type: :user do
      arg :address, :string
      arg :deposit_amount, :integer
      resolve &Resolvers.Casino.user_deposit/3
    end

    @desc "Adds a bet to a game"
    field :add_bet, type: :bet do
      arg :bet, :add_bet_params
      resolve &Resolvers.Casino.add_bet/3
    end

    @desc "Create a new user"
    field :create_user, type: :user do 
      arg :address, non_null(:string)
      resolve &Resolvers.Account.create_user/3
    end

    @desc "Generates Tokens for Specific User"
    field :top_up_balance, type: :user do 
      arg :address, non_null(:string)
      resolve &Resolvers.Account.top_up_balance/3
    end

    @desc "Update an existing user"
    field :update_user, type: :user do
      arg :id, non_null(:integer)
      arg :user, :update_user_params
      resolve &Resolvers.Account.update_user/3
    end

    @desc "Creates a bet for the user"
    field :make_bet, type: :user do
      @desc "address of user making bet"
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

    field :game_updated, :game do
      arg :game_id, non_null(:id)
      config fn args,_ ->
        {:ok, topic: args.game_id}
      end
    end

    field :pot_updated, :pot do
      arg :game_id, non_null(:id)
      config fn args,_ ->
        {:ok, topic: args.game_id}
      end
    end

    field :notify_winner, :game do
      arg :game_id, non_null(:id)
      arg :player_id, non_null(:id)
      config fn args,_ ->
        {:ok, topic: {args.game_id, args.player_id}}
      end
    end

  end
end
