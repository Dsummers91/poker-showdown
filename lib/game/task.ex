defmodule Game.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed on start
    {:ok, state}
  end

  def handle_info(:work, state) do
    file_name = "/tmp/test.log"
    logtext = "rara"
    File.touch file_name
    File.chmod!(file_name,0o755)
    {:ok, file} = File.open file_name, [:append]
    IO.binwrite file, logtext <> "\n"
    File.close file
    {:noreply,file_name}
    # Do the desired work here
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1000) # In 2 hours
  end
end
