defmodule ShowdownWeb.Resolvers.Casino do

  def list_games(_parent, _args, _resolution) do
    {:ok, Showdown.Casino.list_games() 
            |> Enum.map(fn g -> Game.Table.convert(g) end)
            }
  end

  def list_active_games(_parent, _args, _resolution) do
    {:ok, Showdown.Casino.list_active_games()
            |> Enum.map(fn g -> Game.Table.convert(g) end)
            }
  end

  def find_game(_parent, %{id: id}, _resolution) do
    {:ok, Showdown.Casino.find_game(id)
            |> Game.Table.convert}
  end

  def add_bet(_parent, %{bet: %{game_id: game_id, player_name: player_name, user_address: user_address, bet_amount: bet_amount}}, _resolution) do
    Showdown.Casino.get_game!(game_id)
      |> Showdown.Casino.add_bet(player_name, user_address, bet_amount)
  end
end
