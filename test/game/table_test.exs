defmodule TableTest do
  use Showdown.DataCase

  use ExUnit.Case
  require Logger
	alias Game.Dealer
  alias Game.Player
	alias Game.Cards
  alias Game.Deck
  alias Game.Table

  doctest Showdown


  test "should create new table" do
    table = Table.new_game(1000)
    assert(length(table.board) == 0)
    assert(length(table.deck) == 44)
    assert(table.starting_block == 1000)
  end


  test "should deal flop" do
    table = Table.new_game(1000)
    table = Table.deal_round(table)
    assert(length(table.board) == 3)
    assert(length(table.deck) == 41)
  end

  test "should deal turn" do
    table = Table.new_game(1000)
    table = Table.deal_round(table)
    table = Table.deal_round(table)
    assert(length(table.board) == 4)
    assert(length(table.deck) == 40)
  end

  test "should deal river" do
    table = Table.new_game(1000)
    assert(table.round == :preflop)
    table = Table.deal_round(table)
    assert(table.round == :flop)
    table = Table.deal_round(table)
    assert(table.round == :turn)
    table = Table.deal_round(table)
    assert(table.round == :river)
    assert(length(table.board) == 5)
    assert(length(table.deck) == 39)
  end

  test "should be able to update" do
    game = Table.new_game(1000)
    result = Table.update_games([game])
    assert(result == {:ok})
  end
end
