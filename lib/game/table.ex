defmodule Game.Table do
  defstruct [:players, :board, :round, :deck_hash, :flop_block, :turn_block, :river_block]

  alias Game.Deck
  alias Game.Cards

  @type round :: :preflop | :flop | :turn | :river
  @type game_state :: %Game.Table{players: list(Cards.card), board: list(Cards.card), round: round, deck_hash: String.t, flop_block: String.t, turn_block: String.t, river_block: String.t}

  @spec new_game() :: game_state
  def new_game() do
    {:ok, latest_block_hex} = Ethereumex.HttpClient.eth_block_number
    latest_block = ExW3.to_decimal(latest_block_hex)
    IO.puts latest_block_hex
    {players, deck, hash} = Game.Dealer.new_game()
    {players, nil, deck, hash, latest_block+10, latest_block+20, latest_block+30} 
  end
end
