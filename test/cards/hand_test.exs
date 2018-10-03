defmodule HandTest do
  use ExUnit.Case
  alias Game.Hand
  alias Game.Cards
  doctest Showdown


  test "create a hand" do
    assert Hand.create_hand(:player1, [%Cards{number: 14, suit: :diamonds}, %Cards{number: 14, suit: :spades}]) == {[%Cards{number: 14, suit: :diamonds}, %Cards{number: 14, suit: :spades}], []}
  end

end
