defmodule HandTest do
  use ExUnit.Case
  alias Game.Hand
  alias Game.Cards
  alias Game.Deck

  doctest Showdown


  test "create a hand" do
    assert Hand.create_hand(:player1, [%Cards{number: 14, suit: :diamonds}, %Cards{number: 14, suit: :spades}]) == {[%Cards{number: 14, suit: :diamonds}, %Cards{number: 14, suit: :spades}], []}
  end

  test "Should give hand to player1" do
    deck = Deck.new()
    {hand, deck} = Hand.create_hand :player1
    assert(Enum.at(hand, 0).number == Enum.at(hand,1).number)
    assert(length(hand) == 2)
  end
end
