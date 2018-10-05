defmodule Game.Hand do
  require Logger
  @moduledoc "Contains logix to rank hands"
  alias Game.Cards
  alias Game.Deck

  @type player :: :player1 | :player2 | :player3 | :player4
  @type suits :: :suited | :offsuit | :any

  @type hand :: %{ numbers: list(2..14), suits: suits }
  
  def rank(hand) do
    {suits, numbers} =
      hand
        |> suit_number_count
    cond do
      is_straight_flush(hand) -> :straight_flush
      is_flush(suits) -> :flush
      is_straight(numbers, hand) -> :straight
      is_four_of_a_kind(numbers) -> :four_of_a_kind
      is_full_house(numbers) -> :full_house
      is_three_of_a_kind(numbers) -> :three_of_a_kind
      is_two_pair(numbers) -> :two_pair
      is_pair(numbers) -> :one_pair
      true -> :high_card
    end
  end

  def is_flush(suit) do
    Enum.any?(suit, fn x -> elem(x, 1) >= 5 end)
  end

  def is_straight(numbers, hand) do 
    if length(hand) < 5, do: false
    hand
      |> Enum.into([], fn x -> x.number end)
      |> Enum.sort
      |> check_straight
  end

  def check_straight(numbers) do
    Logger.debug List.first(numbers)
    high_number = List.first(numbers)
    low_number = if(List.last(numbers) == 1, do: 14, else: List.last(numbers))
    Enum.all?(numbers, fn x->
      Enum.member?(numbers, high_number) &&
      Enum.member?(numbers, high_number-1) && 
      Enum.member?(numbers, high_number-2) &&
      Enum.member?(numbers, 6) &&
      Enum.member?(numbers, low_number)
    end)
  end

  def is_straight_flush(hand) do
    false
  end

  def is_four_of_a_kind(number) do
    Enum.any?(number, fn x -> elem(x, 1) == 4 end)
  end

  def is_full_house(number) do
    Enum.any?(number, fn x -> elem(x, 1) == 3 end)
     && Enum.any?(number, fn x -> elem(x, 1) == 2 end)
  end

  def is_three_of_a_kind(number) do
    Enum.any?(number, fn x -> elem(x, 1) == 3 end)
  end

  def is_two_pair(number) do
    Enum.count(number, fn x -> elem(x, 1) == 2 end) > 2
  end

  def is_pair(number) do
    Enum.any?(number, fn x -> elem(x, 1) == 2 end)
  end

  def suit_number_count(hand) do
    suits =
      hand
        |> Enum.into([], fn x -> x.suit end)
    suit_count =
      suits
        |> Map.new(&({&1, count(suits, &1)}))

    numbers =
      hand
        |> Enum.into([], fn x -> x.number end)
    number_count =
      numbers
        |> Map.new(&({&1, count(numbers, &1)}))

    {suit_count, number_count}
  end

  def count(hand, card) do
    Enum.count(hand, &(&1 == card))
  end
end
