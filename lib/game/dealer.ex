defmodule Game.Dealer do
  alias Game.Player
  alias Game.Deck
  alias Ethereumex.HttpClient
  alias ExthCrypto.Hash.Keccak


  @type player :: :player1 | :player2 | :player3 | :player4
  @type suits :: :suited | :offsuit | :any

  @type hand :: %{ numbers: list(2..14), suits: suits }

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

 def contains_cards(cards, deck) do
    Enum.member?(deck, List.first(cards)) && Enum.member?(deck, List.last(cards))
 end

  def new_game() do
    {player_1, deck} = deal_to_player(:player1)
    {player_2, deck} = deal_to_player(:player2, deck)
    {player_3, deck} = deal_to_player(:player3, deck)
    {player_4, deck} = deal_to_player(:player4, deck)
    {[player_1, player_2, player_3, player_4], deck, hash_deck(deck)}
  end

  def draw_cards(round, block_number, deck) do
   Game.Blockchain.get_card_position_by_hash(round, block_number)
    |> select_cards(deck)
  end
  
  defp select_cards(offset, deck, board \\ [], offset_length \\ 1)

  defp select_cards(offset, deck, board, offset_length) when offset_length == 0 do
    {board, deck}
  end
  
  defp select_cards([offset | tail], deck, board, offset_length) do
    card = Enum.at(deck, rem(offset, length(deck)))
    board = List.insert_at(board, -1, card)
    deck = List.delete(deck, card)
    select_cards(tail, deck, board, length(tail))
  end


  defp deal_cards() do 

  end

  defp hash_deck(deck) do
    ExthCrypto.Hash.Keccak.kec(Deck.to_string(deck))
  end

end
