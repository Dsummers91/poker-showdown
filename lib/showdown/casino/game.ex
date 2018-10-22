defmodule Showdown.Game do
  use Ecto.Schema
  import Ecto.Changeset


  schema "games" do
    field :board, :integer
    field :round, :string
    field :deck_hash, :string
    field :starting_block, :integer

    has_many :cards, Showdown.GameCards

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:board, :round, :deck_hash, :starting_block])
    |> validate_required([:round])
  end
end
