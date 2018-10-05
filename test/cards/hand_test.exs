defmodule HandTest do
  use ExUnit.Case
  alias Game.Hand
  alias Game.Cards
  alias Game.Deck

  doctest Showdown

  test "should get correct" do
    hand = [Cards.new_card(14, :diamonds), Cards.new_card(14, :clubs)]
    assert(Hand.count([14,14], 14) == 2) 
  end

  test "should return correct suit and numbers" do
    hand = [Cards.new_card(14, :diamonds), Cards.new_card(13, :diamonds)]
    assert(Hand.suit_number_count(hand) == {%{diamonds: 2}, %{13=>1, 14=>1}})
  end

  test "should get pair aces" do
    hand = [Cards.new_card(14, :diamonds), Cards.new_card(14, :clubs)] 
    assert(Hand.rank(hand) == :one_pair)
  end

  test "should get three aces" do
    hand = [Cards.new_card(14, :diamonds), Cards.new_card(14, :clubs), Cards.new_card(14, :spades)]  
    assert(Hand.rank(hand) == :three_of_a_kind)
  end
end
