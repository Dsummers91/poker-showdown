defmodule ShowdownWeb.Resolvers.Casino do

  def list_games(_parent, _args, _resolution) do
    {:ok, Showdown.Casino.list_games() |> Enum.map(fn g -> Game.Table.convert(g) end)}
  end

  def list_active_games(_parent, _args, _resolution) do
    {:ok, Showdown.Casino.list_active_games()}
  end

  def find_game(_parent, %{id: id}, _resolution) do
    {:ok, Showdown.Casino.find_game(id)}
  end
end
