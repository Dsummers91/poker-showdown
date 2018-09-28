defmodule ShowdownWeb.Schema.Accounts do
    use Absinthe.Schema.Notation

    object :user do
          field :id, :id
          field :address, :string
        end
end
