defmodule Showdown.Casino.GameBets do
  use Ecto.Schema
  import Ecto.Changeset


  schema "game_bets" do
    belongs_to :game, Showdown.Game
    belongs_to :player, Showdown.Owner
    belongs_to :user, Showdown.Accounts.User
    field :bet_amount, :integer

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:bet_amount])
    |> validate_required([:game, :player, :user, :bet_amount])
  end
end
