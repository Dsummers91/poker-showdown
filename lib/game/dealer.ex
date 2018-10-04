defmodule Game.Dealer do
  alias Game.Player
  alias Game.Deck

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
end
