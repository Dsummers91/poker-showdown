defmodule Showdown.CasinoTest do
  use Showdown.DataCase

  alias Showdown.Casino

  describe "games" do
    alias Showdown.Game

    @valid_attrs %{round: :flop}
    @update_attrs %{round: :turn}
    @invalid_attrs %{round: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Casino.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Casino.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Casino.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Casino.create_game(@valid_attrs)
      assert game.round == "flop"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Casino.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Casino.update_game(game.id, @update_attrs)
      assert %Game{} = game
      assert game.round == "turn"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Casino.update_game(game, @invalid_attrs)
      assert game == Casino.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Casino.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Casino.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Casino.change_game(game)
    end
  end
end
