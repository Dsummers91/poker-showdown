defmodule Showdown.Casino do
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  The Casino context.
  """

  import Ecto.Query, warn: false
  alias Showdown.Repo

  alias Showdown.Card
  alias Showdown.Game
  alias Showdown.Owner

  #### CARDS ####
  def list_cards do
    Repo.all(Card)
  end

  def get_card!(id), do: Repo.get!(Card, id)

  def create_card(attrs) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  def change_card(%Card{} = card) do
    Card.changeset(card, %{})
  end

  ##### GAMES ####
  def import_game(game) do
    with {:ok, game_created} <- game |> create_game,
      {:ok, _ } <- game |> assign_cards_to_game
    do 
      {:ok, get_game game.id}
    else
      err -> err
    end
  end

  def assign_cards_to_game(game) do
    {:error, "error assigning cards"}
  end

  def update_game(%Showdown.Game{id: id}, game) do
    game
     |> Map.take([:round])
     |> (&(Showdown.Game.changeset(Repo.get(Showdown.Game, id) |> Repo.preload([cards: [:card, :owner]]), &1))).()
     |> Repo.update
  end

  def create_game(game) do
    game
     |> Map.take([:round, :starting_block, :deck_hash, :board])
     |> Map.put_new(:round, "preflop")
     |> (&(Showdown.Game.changeset(%Showdown.Game{}, &1))).()
     |> Repo.insert
  end

  def list_games() do
    Repo.all(Game)
      |> Repo.preload([cards: [:card, :owner]])
  end

  def list_owners() do
    Repo.all(Owner)
  end

  def get_game(id) do
    Repo.get(Game, id)
  end

  def get_game!(id) do
    Repo.get!(Game, id)
  end

  def find_game(id) do
    Repo.get(Game, id)
      |> Repo.preload([cards: [:card, :owner]])
  end

  def list_active_games() do
    Repo.all(from game in Game, where: game.round != "river")
      |> Repo.preload([cards: [:card, :owner]])
  end

  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end
end
