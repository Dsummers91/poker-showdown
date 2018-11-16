defmodule ShowdownWeb.Schema.Accounts do
  use Absinthe.Schema.Notation

  @desc "User of the platform"
  object :user do
    field :id, :id
    @desc "Users Ethereum Address"
    field :address, non_null(:string)
    field :balance, non_null(:integer)
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
    field :board, list_of(:card_details)
    field :player1, list_of(:card_details)
    field :player2, list_of(:card_details)
    field :player3, list_of(:card_details)
    field :player4, list_of(:card_details)
  end

  object :card_details do
    field :id, :id
    field :suit, :string
    field :number, :integer
    field :owner, :string
  end

  object :game do
    field :id, :id
    field :deck, list_of(:card_details)
    field :round, :string
    field :starting_block, :integer
    field :deck_hash, :string
    field :board, list_of(:card)
    field :players, :players
    field :inserted_at, :naive_datetime
    field :winner, :winner
  end

  object :winner do
    field :winner, :owner
  end

  object :bet do
    field :amount, :integer
  end
end

