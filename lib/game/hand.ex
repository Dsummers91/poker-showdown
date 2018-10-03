defmodule Game.Hand do
  alias Game.Cards
  @type player :: :player1 | :player2

  @player_1_hands [
    [Cards.new_card(14, :any), Cards.new_card(14, :any)],
    [Cards.new_card(13, :any), Cards.new_card(13, :any)],
    [Cards.new_card(12, :any), Cards.new_card(12, :any)],
    [Cards.new_card(11, :any), Cards.new_card(11, :any)],
    [Cards.new_card(10, :any), Cards.new_card(10, :any)]
  ]

  @player_2_hands [
    [Cards.new_card(14, :any), Cards.new_card(13, :any)],
    [Cards.new_card(14, :any), Cards.new_card(12, :any)],
    [Cards.new_card(14, :any), Cards.new_card(11, :any)],
    [Cards.new_card(14, :any), Cards.new_card(10, :any)]
  ]

  @player_3_hands [
    [Cards.new_card(5, :any), Cards.new_card(6, :suited)],
    [Cards.new_card(6, :any), Cards.new_card(7, :suited)],
    [Cards.new_card(7, :any), Cards.new_card(8, :suited)],
    [Cards.new_card(8, :any), Cards.new_card(9, :suited)],
    [Cards.new_card(9, :any), Cards.new_card(10, :suited)]
  ]

  @player_4_hands [
    [Cards.new_card(2, :any), Cards.new_card(2, :any)],
    [Cards.new_card(3, :any), Cards.new_card(3, :any)],
    [Cards.new_card(4, :any), Cards.new_card(4, :any)],
    [Cards.new_card(5, :any), Cards.new_card(5, :any)],
    [Cards.new_card(6, :any), Cards.new_card(6, :any)]
  ]

  @doc "create hand for player"
  @spec create_hand(player, list(Cards.card)) :: {list(Cards.card), list(Cards.card)}
  def create_hand(:player1, deck) do 
    {deck, deck}
  end

  def create_hand(:player2, deck) do 
    {"12", deck}
  end

  @spec select_random_hand(list(list(Cards.card))) :: list(Cards.card) 
  def select_random_hand(hands) do
    hands[0]
  end
end
