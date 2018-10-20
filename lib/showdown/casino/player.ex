defmodule Showdown.Player do
  use Ecto.Schema
  import Ecto.Changeset


  schema "players" do
    
    many_to_many :games, Showdown.Game, join_through: "players_games"

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [])
    |> validate_required([])
  end
end
