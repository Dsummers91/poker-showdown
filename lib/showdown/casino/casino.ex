defmodule Showdown.Casino do
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  The Casino context.
  """

  import Ecto.Query, warn: false
  alias Showdown.Repo

  alias Showdown.Card
  alias Showdown.Game

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
  def list_games() do
    Repo.all(Game)
  end

  def find_game(id) do
    Repo.get(Game, id)
  end

  def list_active_games() do
    Repo.all(from game in Game, where: game.round != "river")
  end

end
