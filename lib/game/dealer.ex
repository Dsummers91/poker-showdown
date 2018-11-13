defmodule Game.Dealer do
  alias Game.Player
  alias Game.Deck
  alias Ethereumex.HttpClient
  alias ExthCrypto.Hash.Keccak


  @type player :: :player1 | :player2 | :player3 | :player4
  @type suits :: :suited | :offsuit | :any

  @type hand :: %{ numbers: list(2..14), suits: suits }

 @spec deal_to_player(player, list(Game.Cards.card)) :: {list(Game.Cards.Card), list(Game.Cards.Card)}
 def deal_to_player(player, deck \\ Deck.new()) do
    player_hand = 
      Player.possible_hands(player)
        |> Enum.filter(fn x -> contains_cards(x, deck) end)
        |> Enum.take_random(1)
        |> List.first
    deck = 
      deck
        |> Enum.reject(fn x -> Enum.member?(player_hand, x) end)

    {player_hand, deck}
 end

 @spec contains_cards(list(Game.Cards.Card), list(Game.Cards.Card)) :: boolean
 def contains_cards(cards, deck) do
    Enum.member?(deck, List.first(cards)) && Enum.member?(deck, List.last(cards))
 end

  @spec new_game() :: {list(list(Game.Cards.Card)), list(Game.Cards.Card), String.t}
  def new_game() do
    {player_1, deck} = deal_to_player(:player1)
    {player_2, deck} = deal_to_player(:player2, deck)
    {player_3, deck} = deal_to_player(:player3, deck)
    {player_4, deck} = deal_to_player(:player4, deck)
    {[player_1, player_2, player_3, player_4], deck, hash_deck(deck)}
  end

  def draw_cards(game_id, round, block_number, deck, board \\ [])

  def draw_cards(game_id, :end, block_number, deck, board) do
    {board, deck}
  end

  def draw_cards(game_id, round, starting_block, deck, board) do
    block_number = case round do
      :flop -> starting_block + 40
      :turn -> starting_block + 60
      :river -> starting_block + 80
    end
    board = case board do
      nil -> []
      _ -> board
    end
    Game.Blockchain.get_card_position_by_hash(round, block_number)
      |> select_cards(game_id, deck, board)
  end
  
  defp select_cards(offset, game_id, deck, board \\ [], offset_length \\ 1)

  defp select_cards(offset, game_id, deck, board, offset_length) when offset_length == 0 do
    {board, deck}
  end
  
  defp select_cards([offset | tail], game_id, deck, board, offset_length) do
    card = Enum.at(deck, rem(offset, length(deck)))
    board = List.insert_at(board, -1, card)
    deck = List.delete(deck, card)
    card = Showdown.Casino.assign_cards(game_id, card, "board")
    select_cards(tail, game_id, deck, board, length(tail))
  end

  defp hash_deck(deck) do
    ExW3.keccak256(Deck.to_string(deck))
  end

end
