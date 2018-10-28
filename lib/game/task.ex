defmodule Game.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :game_server)
  end

  def init(state) do
    update_games() 
    {:ok, state}
  end

  def handle_info(:update_games, state) do
    {:ok, latest_block_hex} = Ethereumex.HttpClient.eth_block_number
    latest_block = ExW3.to_decimal(latest_block_hex)
    Showdown.Casino.list_active_games
    |> Enum.map(fn game -> Game.Table.convert(game) end)
    |> Enum.filter(fn game -> Game.Table.is_updatable(game, latest_block) end)
    |> Enum.map(fn game -> Game.Table.deal_round(game) end)
    update_games() # Reschedule once more
    {:noreply, []}
  end

  defp update_games() do
    Process.send_after(self(), :update_games, 2 * 1000) # Every 3 Seconds
  end
end
