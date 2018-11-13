defmodule Game.GameCreator do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :game_creator)
  end

  def init(state) do
    create_games()
    {:ok, state}
  end

  def handle_info(:new_game, state) do
    Game.Table.new_game()
    create_games()
    {:noreply, []}
  end

  defp create_games() do
    Process.send_after(self(), :new_game, 2 * 60 * 1000) # Every 30 seconds
  end
end
