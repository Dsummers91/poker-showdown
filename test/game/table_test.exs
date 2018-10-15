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
    {players, deck, _, hash, flop_block, turn_block, river_block} = Table.new_game()
    assert(flop_block == turn_block - 10) #dumb test
  end
end
