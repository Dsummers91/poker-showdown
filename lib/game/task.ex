defmodule Game.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :game_server)
  end

  def init(state) do
    schedule_work() 
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

  def handle_info(:update_games, state) do
    Game.update_games()
    schedule_work() # Reschedule once more
    {:noreply, []}
  end

  defp schedule_work() do
    Process.send_after(self(), :update_games, 2 * 5 * 1000) # In 5 Seconds
  end
end
