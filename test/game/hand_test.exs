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

  test "should get full house" do
    hand = [Cards.new_card(14, :diamonds), Cards.new_card(14, :clubs), Cards.new_card(14, :spades), Cards.new_card(13, :spades), Cards.new_card(13, :spades)]  
    assert(Hand.rank(hand) == :full_house)
  end

  test "should get four of a kind" do
    hand = [Cards.new_card(14, :diamonds), Cards.new_card(14, :clubs), Cards.new_card(14, :spades), Cards.new_card(13, :spades), Cards.new_card(14, :hearts)]  
    assert(Hand.rank(hand) == :four_of_a_kind)
  end

  test "should get flush" do
    hand = [Cards.new_card(14, :diamonds), Cards.new_card(13, :diamonds), Cards.new_card(12, :diamonds), Cards.new_card(7, :diamonds), Cards.new_card(13, :diamonds)]  
    assert(Hand.rank(hand) == :flush)
  end

  test "straight should return true" do
    hand = [Cards.new_card(9, :spades), Cards.new_card(8, :diamonds), Cards.new_card(7, :diamonds), Cards.new_card(6, :diamonds), Cards.new_card(5, :diamonds)]  
    assert(Hand.is_straight(hand) == true)
  end

  test "should get straight" do
    hand = [Cards.new_card(9, :spades), Cards.new_card(8, :diamonds), Cards.new_card(7, :diamonds), Cards.new_card(6, :diamonds), Cards.new_card(5, :diamonds)]  
    assert(Hand.rank(hand) == :straight)
  end

  test "should get straight flush" do
    hand = [Cards.new_card(9, :diamonds), Cards.new_card(8, :diamonds), Cards.new_card(7, :diamonds), Cards.new_card(6, :diamonds), Cards.new_card(5, :diamonds)]  
    assert(Hand.rank(hand) == :straight_flush)
  end

  test "should get true straight flush" do
    hand = [Cards.new_card(9, :diamonds), Cards.new_card(8, :diamonds), Cards.new_card(7, :diamonds), Cards.new_card(6, :diamonds), Cards.new_card(5, :diamonds)]  
    assert(Hand.is_straight_flush(hand) == true)
  end

  test "should get correct index" do
    Hand.get_index(:straight_flush) == 0
  end

  test "should get two pair" do
    hand = [  Cards.new_card(11, :diamonds), 
              Cards.new_card(8, :clubs), 
              Cards.new_card(2, :hearts), 
              Cards.new_card(12, :diamonds), 
              Cards.new_card(13, :spades), 
              Cards.new_card(12, :hearts), 
              Cards.new_card(13, :diamonds)]  
    {suits, numbers} = hand |> Hand.suit_number_count
    assert(Hand.is_two_pair(numbers) == true)
  end
end
