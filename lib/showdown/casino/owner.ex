defmodule Showdown.Owner do
  use Ecto.Schema
  import Ecto.Changeset


  schema "owners" do
    field :name, :string
    
    many_to_many :games, Showdown.Game, join_through: "player_games"

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [])
    |> validate_required([])
  end
end
