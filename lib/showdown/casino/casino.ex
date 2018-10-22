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
    game
      |> create_game
  end

  def update_game(id, game) do
    game
     |> Map.take([:round, :starting_block])
     |> Map.put(:round, Atom.to_string(game.round))
     |> (&(Showdown.Game.changeset(Repo.get(Showdown.Game, id), &1))).()
     |> Repo.insert
  end

  def create_game(game) do
    game
     |> Map.take([:round, :starting_block])
     |> Map.put(:round, Atom.to_string(game.round))
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

  def find_game(id) do
    Repo.get(Game, id)
      |> Repo.preload([cards: [:card, :owner]])
  end

  def list_active_games() do
    Repo.all(from game in Game, where: game.round != "river")
      |> Repo.preload([cards: [:card, :owner]])
  end

end
