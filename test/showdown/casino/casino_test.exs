defmodule Showdown.CasinoTest do
  use Showdown.DataCase

  alias Showdown.Casino
  alias Showdown.Repo

  describe "games" do

    @valid_attrs %{deck_hash: "0x", starting_block: 1000}
    @update_attrs %{round: "turn"}
    @invalid_attrs %{}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Casino.create_game()
      
      card = Showdown.Repo.get(Showdown.Card, 1)
      owner = Showdown.Repo.get(Showdown.Owner, 1)

      gc = %Showdown.GameCards{} 
            |> Ecto.Changeset.change()
            |> Ecto.Changeset.put_assoc(:card, card)
            |> Ecto.Changeset.put_assoc(:owner, owner)
            |> Ecto.Changeset.put_assoc(:game, game)
            |> Showdown.Repo.insert!

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Casino.list_games() == [game |> Repo.preload([cards: [:card, :owner]])]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Casino.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Showdown.Game{} = game} = Casino.create_game(@valid_attrs)
      assert game.round == "preflop"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Casino.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Casino.update_game(game, @update_attrs)
      assert %Showdown.Game{} = game
      assert game.round == "turn"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Casino.update_game(game, %{round: nil})
      assert game == Casino.get_game!(game.id)
    end

    @tag :skip
    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Showdown.Game{}} = Casino.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Casino.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Casino.change_game(game)
    end

    test "should convert game to table" do
        game = game_fixture()
                |> Repo.preload([cards: [:card, :owner]])
                |> Game.Table.convert
      assert Map.has_key?(game, :id)
      assert length(Map.get(game.players, :player1)) == 1
    end
  end
end
