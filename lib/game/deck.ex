defmodule Game.Deck do 
  alias Game.Cards

  @spec new() :: list(Cards.card)
  def new() do
    for suit <- [:hearts, :clubs, :diamonds, :spades], num <- 2..14 do
        %Cards{number: num, suit: suit}
    end
  end

end
