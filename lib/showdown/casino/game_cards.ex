defmodule Showdown.GameCards do
  use Ecto.Schema
  import Ecto.Changeset


  schema "game_cards" do
    belongs_to :game, Showdown.Game
    belongs_to :card, Showdown.Card
    field :owner, :string
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [])
    |> validate_required([])
  end
end
