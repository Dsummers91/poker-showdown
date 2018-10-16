defmodule TableTest do
  use ExUnit.Case
  require Logger
	alias Game.Dealer
  alias Game.Player
	alias Game.Cards
  alias Game.Deck
  alias Game.Table

  doctest Showdown


  test "should create new table" do
    table = Table.new_game()
    assert(length(table.board) == 3)
    assert(length(table.deck) == 41)
    assert(table.flop_block == table.turn_block - 10) #dumb test
  end
end
