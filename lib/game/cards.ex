defmodule Game.Cards do
  defstruct [:number, :suit]

  @type suit :: :clubs | :diamonds | :hearts | :spades | :any | :suited
  @type card_number :: 2..14

  @type card :: %Game.Cards{number: card_number, suit: suit}

  @spec return_suit() :: suit()
  def return_suit() do
    :hearts
  end
  
  @spec new_card(card_number, suit) :: card()
  def new_card(num, suit) do
    %Game.Cards{number: num, suit: suit}
  end

end
