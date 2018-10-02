defmodule Game.Hand do
  @type player :: :player1 | :player2

  @player_1_hands [Cards.new_card()]

  @spec create_hand(player, list(Cards.card)) :: list(Cards.card)
  @doc "create tier 1 hand"
  def create_hand(:player1, deck) do
    deck
  end

  def create_hand(:player2, deck) do
    deck
  end
  
end
