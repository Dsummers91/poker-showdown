defmodule Game.Deck do 
  alias Game.Cards

  @spec new() :: list(Cards.card)
  def new() do
    for suit <- [:hearts, :clubs, :diamonds, :spades], num <- 2..14 do
        %Cards{number: num, suit: suit}
    end
  end

  @spec to_string(list(Cards.card)) :: String.t
  def to_string(deck) do
    for card <- deck do
      case card do
        %Cards{number: x, suit: :diamonds} -> Integer.to_string(x)<>"d"
        %Cards{number: x, suit: :hearts} -> Integer.to_string(x)<>"h"
        %Cards{number: x, suit: :spades} -> Integer.to_string(x)<>"s"
        %Cards{number: x, suit: :clubs} -> Integer.to_string(x)<>"c"
      end
    end 
      |> List.to_string()
  end

  def get_deck(game) do
    cards = game.cards
      |> Enum.map(fn card -> %Cards{number: card.card.number, suit: String.to_existing_atom(card.card.suit)} end)
    deck = new()
      |> Enum.reject(fn card -> Enum.member?(cards, card) end)

    Map.put(game, :deck, deck)
  end
end
