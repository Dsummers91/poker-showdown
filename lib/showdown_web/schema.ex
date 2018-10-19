defmodule ShowdownWeb.Schema do
  use Absinthe.Schema
  import_types ShowdownWeb.Schema.Accounts

  alias ShowdownWeb.Resolvers

  input_object :update_user_params do
    field :address, non_null(:string)
  end


  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Resolvers.Account.list_users/3
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
  end

end
