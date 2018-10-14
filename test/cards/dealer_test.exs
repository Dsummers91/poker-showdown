defmodule DealerTest do
  use ExUnit.Case
  require Logger
	alias Game.Dealer
  alias Game.Player
	alias Game.Cards
  alias Game.Deck
  doctest Showdown


  test "should contain an ace" do
    deck = Deck.new()
		ace_deck = [%Cards{number: 14, suit: :diamonds}, %Cards{number: 14, suit: :clubs}]
    assert(Dealer.contains_cards(ace_deck, ace_deck) == true)
	end

  test "should deal player1 hand" do
    deck = Deck.new()
    {hand, deck} = Dealer.deal_to_player(:player1)
		assert(length(hand) == 2)
		assert(length(deck) == 50)
	end

  test "should deal player2 hand" do
    deck = Deck.new()
    {hand, deck} = Dealer.deal_to_player(:player1)
    {hand, deck} = Dealer.deal_to_player(:player2, deck)
		assert(length(hand) == 2)
		assert(length(deck) == 48)
	end
  test "should deal all hand" do
    deck = Deck.new()
    {hand, deck} = Dealer.deal_to_player(:player1)
    {hand, deck} = Dealer.deal_to_player(:player2, deck)
    {hand, deck} = Dealer.deal_to_player(:player3, deck)
    {hand, deck} = Dealer.deal_to_player(:player4, deck)
		assert(length(hand) == 2)
		assert(length(deck) == 44)
  end

  test "should create game" do
    {players, deck, block} = Dealer.new_game()
		assert(length(deck) == 44)
  end

end
