defmodule Game.Table do
  defstruct [:players, :board, :deck, :round, :deck_hash, :starting_block]

  alias Game.Deck
  alias Game.Cards

  @type round :: :preflop | :flop | :turn | :river

  
  @type game_state :: %Game.Table{
                        players: list(list(Cards.card)), 
                        deck: list(Cards.card), 
                        board: list(Cards.card), 
                        round: atom, 
                        deck_hash: String.t, 
                        starting_block: integer}

  @spec new_game() :: game_state
  def new_game(block \\ 0) do
    {:ok, latest_block_hex} = Ethereumex.HttpClient.eth_block_number
    latest_block = if Application.get_env(:showdown, :env) != :test, do: ExW3.to_decimal(latest_block_hex), else: block
    {players, deck, hash} = Game.Dealer.new_game()
    table = %Game.Table{players: players, board: [], round: :preflop, deck: deck, deck_hash: hash, starting_block: latest_block} 
    ##WAIT FOR BETS
    table
  end

  def update_games([]) do
    {:ok, 0}
  end

  def update_games([game | games]) do
    case check_update(game) do
      :needs_update -> {:ok}
      _ -> {:error}
    end
  end
  
  defp check_update(%Game.Table{round: current_round, starting_block: starting_block}) do
    {:ok, latest_block_hex} = Ethereumex.HttpClient.eth_block_number
    latest_block = ExW3.to_decimal(latest_block_hex)
    IO.inspect latest_block, label: "latest_block"
    IO.inspect starting_block, label: "starting_block"
    cond do
      latest_block >  starting_block -> :needs_update
      latest_block <= starting_block -> :up_to_date
    end
  end

  def deal_round(table) do
    #Get Table from DB
    table = Map.put(table, :round, advance_round(table))
    {board, deck} = Game.Dealer.draw_cards(table.round, table.starting_block+10, table.deck, table.board)
    table = Map.put(table, :board, board) 
    table = Map.put(table, :deck, deck) 
    table
  end

  def end_game() do
    
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
