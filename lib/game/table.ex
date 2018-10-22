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
    db = Showdown.Casino.create_game(table)
    table
  end

  def update_games([]) do
    {:ok, 0}
  end

  def update_game(game) do
    Showdown.Repo.get(Showdown.Game, 1)
      |> Ecto.Changeset.change(%{round: "river"})
      |> Showdown.Repo.update!
  end

  def convert(%Showdown.Game{} = game) do
    game
      |> Map.take([:round, :starting_block, :deck_hash, :cards])
      |> assign_card_owners()
      |> (&(struct(Game.Table, &1))).()
   
  end

  # allocates cards to owners [board, players1..4] key
  defp assign_card_owners(game) do
    game.cards
        |> Enum.group_by(&(&1.owner.name), (&(&1.card)))
        |> (&(put_in(game[:players], &1))).()
  end

  def convert(%Game.Table{} = table) do

  end
 
  def is_updatable(%Game.Table{starting_block: starting_block, board: board}, current_block) do
    is_ready(board, starting_block, current_block)
  end

  defp is_ready([], starting_block, current_block) do
    true
  end

  defp is_ready(board, starting_block, current_block) when length(board == 3) do
    true
  end

  defp is_ready(board, starting_block, current_block) when length(board == 4) do
    true
  end

  defp is_ready(board, starting_block, current_block) when length(board == 5) do
    true
  end

  defp is_ready(board, starting_block, current_block) do
    #error.. shouldnt get here
    false
  end

  defp check_update(%Showdown.Game{round: current_round, starting_block: starting_block}) do
    {:ok, latest_block_hex} = Ethereumex.HttpClient.eth_block_number
    latest_block = ExW3.to_decimal(latest_block_hex)
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
