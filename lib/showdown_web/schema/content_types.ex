defmodule ShowdownWeb.Schema.Accounts do
    use Absinthe.Schema.Notation

    object :user do
          field :id, :id
          field :address, :string
        end
end

defmodule ShowdownWeb.Schema.Games do
  use Absinthe.Schema.Notation
  import_types Absinthe.Type.Custom

  object :owner do
    field :name, :string
    field :id, :id
  end
  
  object :card do
    field :card, :card_details
    field :owner, :owner
  end

  object :players do
    field :player1, list_of(:card_details)
  end

  object :card_details do
    field :suit, :string
    field :number, :integer
    field :owner, :string
  end

  object :game do
    field :id, :id
    field :cards, list_of(:card)
    field :round, :string
    field :starting_block, :integer
    field :deck_hash, :string
    field :board, list_of(:card)
    field :players, :players
    field :inserted_at, :naive_datetime
  end
end

