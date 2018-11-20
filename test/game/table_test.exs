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
    table = Table.new_game(1)
    assert(table.board == nil)
    assert(length(table.deck) == 44)
    assert(table.starting_block == 1)
  end


  test "should deal flop" do
    table = Table.new_game(1)
    table = Table.deal_round(table)
    assert(length(table.board) == 3)
    assert(length(table.deck) == 41)
  end

  test "should deal turn" do
    table = Table.new_game(1)
    table = Table.deal_round(table)
    assert(length(table.board) == 3)
    table = Table.deal_round(table)
    assert(length(table.board) == 4)
    assert(length(table.deck) == 40)
  end

  test "should deal river" do
    game_cards = Showdown.Repo.all(Showdown.GameCards)
    assert length(game_cards) == 0
    table = Table.new_game(1)
    game_cards = Showdown.Repo.all(Showdown.GameCards)
    assert length(game_cards) == 8
    assert(table.round == :preflop)
    table = Table.deal_round(table)
    game_cards = Showdown.Repo.all(Showdown.GameCards)
    assert length(game_cards) == 11
    assert(table.round == :flop)
    table = Table.deal_round(table)
    game_cards = Showdown.Repo.all(Showdown.GameCards)
    assert length(game_cards) == 12
    assert(table.round == :turn)
    table = Table.deal_round(table)
    assert(table.round == :river)
    game_cards = Showdown.Repo.all(Showdown.GameCards)
    assert length(game_cards) == 13
    assert(length(table.board) == 5)
    assert(length(table.deck) == 39)
    table = Table.deal_round(table)
    assert(length(table.board) == 5)
  end

  @tag :skip
  test "should return currectly updatable statuses" do
    game =  %Game.Table{starting_block: 1000, round: :preflop}
    assert Game.Table.is_updatable(game, 1014) == false
    assert Game.Table.is_updatable(game, 1015) == true
    game =  %Game.Table{starting_block: 2204, round: :flop}
    assert Game.Table.is_updatable(game, 2223) == false
    assert Game.Table.is_updatable(game, 2224) == true
  end

  @tag :skip
  test "should be able to update" do
    game = Table.new_game(2)
    result = Table.update_game(game, 1)
    assert(result == {:ok})
  end

  test "should get a winner" do
    table = Table.new_game(5)
      |> Table.deal_round()
      |> Table.deal_round()
      |> Table.deal_round()
    Showdown.Casino.get_game(table.id)
      |> (&(assert(&1.winner.winner_id == 1))).()
  end

  test "should award bet" do
    table = Table.new_game(2)
    
    Showdown.Accounts.create_user(%{address: "0x"})
    Showdown.Accounts.create_user(%{address: "0x4"})
    Showdown.Accounts.make_bet(%{address: "0x", bet: %{game_id: table.id, winner: "player1", amount: 1000 }})
    Showdown.Accounts.make_bet(%{address: "0x4", bet: %{game_id: table.id, winner: "player2", amount: 500 }})

    table
      |> Table.deal_round()
      |> Table.deal_round()
      |> Table.deal_round()

    
  end
end
