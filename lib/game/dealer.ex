defmodule Game.Dealer do
  alias Game.Player
  alias Game.Deck
  alias Ethereumex.HttpClient

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
    {:ok, result} = HttpClient.eth_get_block_by_number("latest", false, [])
    IO.puts Map.get(result, "number")
    {[player_1, player_2, player_3, player_4], deck, Map.get(result, "hash")}
  end
end
