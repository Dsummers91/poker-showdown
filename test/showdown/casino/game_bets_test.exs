defmodule Showdown.GameBetsTest do
  use Showdown.DataCase

  alias Showdown.Accounts
  alias Showdown.Casino.GameBets
  alias Showdown.Repo

  describe "game_bets" do

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(%{round: "preflop", starting_block: 1, deck_hash: "0x"})
        |> Showdown.Casino.create_game()
      

      game
    end

    test "should add a bet to game" do
      player = Showdown.Repo.get_by(Showdown.Owner, %{name: "player1"})
      {:ok, user} = %{address: "0x", balance: 1000}
                        |> Accounts.create_user
      game = game_fixture()
      {:ok, gb}  = %GameBets{} 
            |> Ecto.Changeset.change()
            |> Ecto.Changeset.put_assoc(:player, player)
            |> Ecto.Changeset.put_assoc(:user, user)
            |> Ecto.Changeset.put_assoc(:game, game)
            |> Ecto.Changeset.put_change(:bet_amount, 1000)
            |> Showdown.Repo.insert
      assert gb.id != nil
      assert Map.get(gb.player, :name) == "player1"
      assert Map.get(gb.user, :address) == "0x"
      assert Map.get(gb, :bet_amount) == 1000
    end

    test "should add a bet to game using func" do
      player = Showdown.Repo.get_by(Showdown.Owner, %{name: "player1"})
      {:ok, user} = %{address: "0x", balance: 1000}
                        |> Accounts.create_user

      game = game_fixture()
      {:ok, gb} = Showdown.Casino.add_bet(game, "player1", "0x", 1000)
      assert gb.id != nil
      assert Map.get(gb.player, :name) == "player1"
      assert Map.get(gb.user, :address) == "0x"
      assert Map.get(gb, :bet_amount) == 1000

      game = Repo.get(Showdown.Game, gb.game.id) |> Repo.preload([:bets])

      assert length(game.bets) == 1
    end
  end
end
