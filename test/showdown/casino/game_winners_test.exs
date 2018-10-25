defmodule Showdown.GameWinnersTest do
  use Showdown.DataCase

  alias Showdown.Casino.GameWinners
  alias Showdown.Repo

  describe "game_winners" do

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(%{round: "preflop", starting_block: 1, deck_hash: "0x"})
        |> Showdown.Casino.create_game()
      

      game
    end

    test "should add a winner to game" do

      winner = Showdown.Repo.get_by(Showdown.Owner, %{name: "player1"})
      game = game_fixture()
      gc = %GameWinners{} 
            |> Ecto.Changeset.change()
            |> Ecto.Changeset.put_assoc(:winner, winner)
            |> Ecto.Changeset.put_assoc(:game, game)
            |> Showdown.Repo.insert!

      assert gc.id != nil
      assert Map.get(gc.winner, :name) == "player1"
    end
  end
end
