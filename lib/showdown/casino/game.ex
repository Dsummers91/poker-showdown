defmodule Showdown.Game do
  use Ecto.Schema
  import Ecto.Changeset


  schema "games" do
    field :round, :string
    field :deck_hash, :string
    field :starting_block, :integer

    has_many :bets, Showdown.Casino.GameBets
    has_many :cards, Showdown.GameCards

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:round, :deck_hash, :starting_block])
    |> validate_required([:round, :starting_block, :deck_hash])
  end
end
