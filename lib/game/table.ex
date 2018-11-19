defmodule Game.Table do

  defstruct [:id, :players, :board, :deck, :round, :deck_hash, :starting_block, :winner]

  alias Game.Deck
  alias Game.Cards

  @type round :: :preflop | :flop | :turn | :river
  
  @type players :: %{"player1": list(Cards.card)}
  @type game_state :: %Game.Table{
                        id: integer,
                        players: list(list(Cards.card)), 
                        deck: list(Cards.card), 
                        board: list(Cards.card), 
                        round: atom, 
                        winner: atom,
                        deck_hash: String.t, 
                        starting_block: integer}

  @spec new_game() :: game_state
  def new_game(block \\ 0) do
    {:ok, latest_block_hex} = Ethereumex.HttpClient.eth_block_number
    latest_block = if Application.get_env(:showdown, :env) != :test, do: ExW3.to_decimal(latest_block_hex), else: block
    {players, deck, hash} = Game.Dealer.new_game()
    table = %Game.Table{players: players, board: [], round: :preflop, deck: deck, deck_hash: hash, starting_block: latest_block} 
    {:ok, table} = Showdown.Casino.create_game(table)
    table = table
      |> Showdown.Repo.preload([cards: [:card, :owner]])
      |> convert
    Absinthe.Subscription.publish(ShowdownWeb.Endpoint, table, [game_created: "game"])
    table
  end

  def convert(%Showdown.Game{} = game) do
    game
      |> Map.take([:winner, :id, :round, :starting_block, :deck_hash, :cards])
      |> Game.Deck.get_deck()
      |> assign_card_owners()
      |> (&(struct(Game.Table, &1))).()
      |> Map.update!(:round, &(String.to_existing_atom(&1)))
  end

  # allocates cards to owners [board, players1..4] key
  defp assign_card_owners(%{cards: []} = game) do
    game
  end

  defp assign_card_owners(game) do
    game.cards
        |> Enum.group_by(&(String.to_existing_atom(&1.owner.name)), (&(&1.card)))
        |> (&(put_in(game[:players], &1))).()
  end


  def is_updatable(%Game.Table{starting_block: starting_block, round: round}, current_block) do
    is_ready(round, starting_block, current_block)
  end

  defp is_ready(:preflop, starting_block, current_block) do
    current_block >= starting_block + Application.get_env(:showdown, :preflop_blocks) + Application.get_env(:showdown, :number_of_confirmations)
  end

  defp is_ready(:flop, starting_block, current_block) do
    current_block >= starting_block + Application.get_env(:showdown, :flop_blocks) + Application.get_env(:showdown, :number_of_confirmations)
  end

  defp is_ready(:turn, starting_block, current_block) do
    current_block >= starting_block + Application.get_env(:showdown, :turn_blocks) + Application.get_env(:showdown, :number_of_confirmations)
  end
  
  defp is_ready(:river, starting_block, current_block) do
    current_block >= starting_block + Application.get_env(:showdown, :river_blocks) + Application.get_env(:showdown, :number_of_confirmations)
  end

  defp is_ready(board, starting_block, current_block) do
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
    table = Showdown.Casino.get_game(table.id)
              |> Showdown.Repo.preload([cards: [:card, :owner]])
              |> convert

    table = Map.put(table, :round, advance_round(table))
    table
      |> Map.update!(:round, &(to_string(&1)))
      |> (&(Showdown.Casino.update_game(%Showdown.Game{id: table.id},&1))).()
    {board, deck} = Game.Dealer.draw_cards(table.id, table.round, table.starting_block, table.deck, Map.get(table.players, :board))
    table = Map.put(table, :board, board) 
    table = Map.put(table, :deck, deck) 
    Absinthe.Subscription.publish(ShowdownWeb.Endpoint, table, [game_updated: table.id])
    table
  end

  def end_game(table) do
    winner = Game.Hand.compare_hands(table)
    Showdown.Casino.insert_winner(table, winner)
    award_winners(table, winner)
  end

  @doc "awards users who bet on correct person"
  def award_winners(table, winner) do
    winners = Showdown.Casino.get_bets_by_game_winner(table.id, to_string(winner))
    total_pot = Showdown.Casino.total_bets(table.id)
  end

  def advance_round(table) do
    round = case table.round do 
      x when is_binary(x) -> String.to_existing_atom(x)
      x -> x
    end
    round = case round do
      :preflop -> :flop
      :flop -> :turn
      :turn -> :river
      :river -> :end
      :end -> :end
    end
    if round == :river, do: end_game(table)
    round
  end
end
