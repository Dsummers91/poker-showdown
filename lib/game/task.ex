defmodule Game.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :game_server)
  end

  def init(state) do
    spawn(fn -> create_games() end)
    update_games() 
    {:ok, state}
  end

  def get_messages do
    GenServer.call(:game_server, :get_messages)
  end

  def get_messages do
    GenServer.call(:game_server, :get_messages)
  end

  def add_message(message) do
    GenServer.call(:game_server, {:add_message, message})
  end

  def remove_message do
    GenServer.call(:game_server, {:remove_message})
  end

  def handle_call({:remove_message}, _from, [removed | messages]) do
    {:reply, messages, messages}
  end

  def handle_call({:add_message, new_message}, _from, messages) do
    {:reply, [new_message | messages], [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end

  def handle_info(:new_game, state) do
    Game.Table.new_game()
    create_games()
    {:noreply, []}
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
    Process.send_after(self(), :update_games, 3 * 1000) # Every 3 Seconds
  end

  defp create_games() do
    Process.send_after(self(), :new_game, 5 * 1000) # Every 5 minutes
  end
end
