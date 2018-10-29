defmodule Game.StateChannel do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :state_channel)
  end

  def init(state) do
    ExW3.Contract.start_link
    ExW3.Contract.register(:StateChannel, abi: ExW3.load_abi(Application.get_env(:showdown, :abi_location)))
    ExW3.Contract.at(:StateChannel, Application.get_env(:showdown, :address))
    {:ok, filter_id} = ExW3.Contract.filter(:StateChannel, "ChannelOpenned", %{fromBlock: 0, toBlock: "latest"})

    IO.inspect Application.get_env(:showdown, :address), label: "Address"
    IO.inspect filter_id, label: "filter"
    # After some point that we think there are some new changes
    IO.inspect ExW3.Contract.call(:StateChannel, :getChannelCloseHash, ["0x", 1000]), label: "channel close hash"
    {:ok, changes} = ExW3.Contract.get_filter_changes(filter_id)
    IO.inspect changes, label: "initial"
    ExW3.Contract.uninstall_filter(filter_id)
    listen_for_event()
    {:ok, state}
  end

  def handle_call({:deposit, address, amount}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:withdraw, address, amount}, _from, state) do
    {:ok, result} = call = ExW3.Contract.call(:StateChannel, :getChannelCloseHash, ["dssa", 10000])
    call = ExW3.bytes_to_string(result)
    {:reply, call, state}
  end

  def handle_call({:confirm_withdraw, address, amount}, _from, state) do
    {:reply, state, state}
  end

  def listen_for_event do
  {:ok, filter_id} = ExW3.Contract.filter(:StateChannel, "ChannelOpenned", %{fromBlock: 0, toBlock: "latest"})
    {:ok, changes} = ExW3.Contract.get_filter_changes(filter_id) # Get our changes from the blockchain
    handle_changes(changes) # Some function to deal with the data. Good place to use pattern matching.
  end

  def handle_changes(changes) do
    IO.inspect "blah"
    IO.inspect changes
  end
end


ExW3.Contract.call(:StateChannel, :channel, ["0x1813cad396d8cd96942a18b296ba7e1c3bf58249966b9bffb315b891cec74ddc"])
