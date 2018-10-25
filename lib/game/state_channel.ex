defmodule Game.StateChannel do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :state_channel)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:deposit, address, amount}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:withdraw, address, amount}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:confirm_withdraw, address, amount}, _from, state) do
    {:reply, state, state}
  end
  
end
