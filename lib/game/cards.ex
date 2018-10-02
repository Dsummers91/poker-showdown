defmodule Game.Cards do
  defstruct [:number, :suit]

  @type suit :: :clubs| :diamonds | :hearts | :spades 
  @type card_number :: 2..14

  @type card :: %Game.Cards{number: card_number, suit: suit}

  @spec return_suit() :: suit()
  def return_suit() do
    :hearts
  end
  
  @spec new_card() :: card()
  def new_card() do
    %Game.Cards{number: 2, suit: :hearts}
  end


end
