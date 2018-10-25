defmodule Showdown.Casino.GameWinners do
  use Ecto.Schema
  import Ecto.Changeset


  schema "game_winners" do
    belongs_to :game, Showdown.Game
    belongs_to :winner, Showdown.Owner
    field :prize_pool, :integer
    
    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [])
    |> validate_required([])
  end
end
