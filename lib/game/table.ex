defmodule Game.Table do
  defstruct [:players, :board, :deck, :round, :deck_hash, :flop_block, :turn_block, :river_block]

  alias Game.Deck
  alias Game.Cards

  @type round :: :preflop | :flop | :turn | :river

  
  @type game_state :: %Game.Table{
                        players: list(list(Cards.card)), 
                        deck: list(Cards.card), 
                        board: list(Cards.card), 
                        round: atom, 
                        deck_hash: String.t, 
                        flop_block: String.t, 
                        turn_block: String.t, 
                        river_block: String.t}

  @spec new_game() :: game_state
  def new_game() do
    {:ok, latest_block_hex} = Ethereumex.HttpClient.eth_block_number
    latest_block = ExW3.to_decimal(latest_block_hex)
    latest_block = 10000
    Showdown.Accounts.create_user(%{address: "test"})
    {players, deck, hash} = Game.Dealer.new_game()
    table = %Game.Table{players: players, board: [], round: :preflop, deck: deck, deck_hash: hash, flop_block: latest_block+10, turn_block: latest_block+20, river_block: latest_block+30} 
    ##WAIT FOR BETS
    table = Map.put(table, :round, advance_round(table))
    {board, deck} = Game.Dealer.draw_cards(table.round, latest_block+10, table.deck, table.board)
    table = Map.put(table, :round, advance_round(table))
    table = Map.put(table, :board, board) 
    table = Map.put(table, :deck, deck) 
    table
  end


  def advance_round(table) do
    case Map.get(table, :round) do
      :preflop -> :flop
      :flop -> :turn
      :turn -> :river
      :river -> :end
      _ -> :preflop
    end
  end
end
