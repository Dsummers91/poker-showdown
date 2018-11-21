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

    test "should not be able bet during turn" do
      player = Showdown.Repo.get_by(Showdown.Owner, %{name: "player1"})
      {:ok, user} = %{address: "0x", balance: 1000}
                    |> Accounts.create_user

      game = game_fixture()
      {:ok, game} = Showdown.Casino.update_game(game, %{round: "turn"})
      {error, _} = Showdown.Casino.add_bet(game, "player1", "0x", 1000)
      assert error == :error
    end

    test "should add a bet to game using func" do
      player = Showdown.Repo.get_by(Showdown.Owner, %{name: "player1"})
      {:ok, user} = %{address: "0x", balance: 7000}
                        |> Accounts.create_user

      game = game_fixture()
      {:ok, gb} = Showdown.Casino.add_bet(game, "player1", "0x", 1000)
      assert gb.id != nil
      assert Map.get(gb.player, :name) == "player1"
      assert Map.get(gb.user, :address) == "0x"
      assert Map.get(gb, :bet_amount) == 1000

      game = Repo.get(Showdown.Game, gb.game.id) |> Repo.preload([:bets])

      assert length(game.bets) == 1
      {:ok, gb} = Showdown.Casino.add_bet(game, "player1", "0x", 2000)
      assert Showdown.Casino.total_bets(game.id) == %{"player1" => 3000, "total" => 3000}
      game2 = Repo.get(Showdown.Game, 2) |> Repo.preload([:bets])
      {:ok, gb} = Showdown.Casino.add_bet(game, "player2", "0x", 2000)
      assert Showdown.Casino.total_bets(game.id) == %{"player1" => 3000, "player2" => 2000, "total" => 5000}
    end
  end
end
