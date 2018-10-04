defmodule PlayerTest do
  use ExUnit.Case
  alias Game.Player
  alias Game.Deck
  doctest Showdown

  @tag :skip
  test "All Possible Aces" do
    range =  [[%{numbers: [14,14], suits: :offsuit}]]
    deck = Deck.new()
    assert(Player.possible_hands(:player1) == [
      [%Game.Cards{number: 14, suit: :hearts}, %Game.Cards{number: 14, suit: :spades}],
      [%Game.Cards{number: 14, suit: :hearts}, %Game.Cards{number: 14, suit: :clubs}],
      [%Game.Cards{number: 14, suit: :hearts}, %Game.Cards{number: 14, suit: :diamonds}],

      [%Game.Cards{number: 14, suit: :spades}, %Game.Cards{number: 14, suit: :club}],
      [%Game.Cards{number: 14, suit: :spades}, %Game.Cards{number: 14, suit: :diamonds}],

      [%Game.Cards{number: 14, suit: :clubs}, %Game.Cards{number: 14, suit: :diamonds}],
    ])
  end
end
