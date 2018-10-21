defmodule Showdown.GameCards do
  use Ecto.Schema
  import Ecto.Changeset


  schema "game_cards" do
    belongs_to :game, Showdown.Game
    belongs_to :card, Showdown.Card
    belongs_to :owner, Showdown.Owner
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [])
    |> validate_required([])
  end
end
