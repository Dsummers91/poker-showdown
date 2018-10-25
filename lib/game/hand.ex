defmodule Game.Hand do
  require Logger
  @moduledoc "Contains logix to rank hands"
  alias Game.Cards
  alias Game.Deck

  @type player :: :player1 | :player2 | :player3 | :player4
  @type suits :: :suited | :offsuit | :any

  @type hand :: %{ numbers: list(2..14), suits: suits }
  
  @ranks [:straight_flush, :flush, :straight, :four_of_a_kind, :full_house, :three_of_a_kind, :two_pair, :one_pair, :high_card]

  def get_index(rank) do
   Enum.find_index(@ranks, fn x -> x == rank end)
  end

  def rank(hand) do
    {suits, numbers} =
      hand
        |> suit_number_count

    cond do
      is_straight_flush(hand) -> :straight_flush
      is_flush(suits) -> :flush
      is_straight(hand) -> :straight
      is_four_of_a_kind(numbers) -> :four_of_a_kind
      is_full_house(numbers) -> :full_house
      is_three_of_a_kind(numbers) -> :three_of_a_kind
      is_two_pair(numbers) -> :two_pair
      is_pair(numbers) -> :one_pair
      true -> :high_card
    end
  end
  
  def compare_hands(%Game.Table{players: players}) do
    players
      |> Map.pop(:board)
      |> (&(Enum.map(elem(&1, 1), fn player -> {elem(player, 0), get_index(rank(List.flatten([elem(&1,0) |  elem(player, 1)])))} end))).()
      |> List.keysort(1)
      |> List.first
      |> elem(0)
  end

  def is_flush(suit) do
    Enum.any?(suit, fn x -> elem(x, 1) >= 5 end)
  end

  def is_straight(hand) do 
    hand
      |> Enum.sort_by(&(&1.number), &(&1 >= &2))
      |> Enum.uniq_by(fn x -> x.number end)
      |> Enum.any?(fn x -> check_straight(x, hand) end)
  end

  def check_straight(starting_card, cards) do
    if length(cards) < 5, do: false
    numbers = Enum.map(cards, fn card -> card.number end)
    low_number = if starting_card.number-4 == 1, do: 14, else: (starting_card.number-4)
    if low_number <= 1 do 
      false
    else 
      Enum.member?(numbers, starting_card.number) &&
        Enum.member?(numbers, starting_card.number-1) &&
          Enum.member?(numbers, starting_card.number-2) &&
            Enum.member?(numbers, starting_card.number-3) &&
              Enum.member?(numbers, low_number)
    end
  end

  def is_straight_flush(hand) do
    {suits, _} =
      hand
        |> suit_number_count
    suit = case  List.first(Enum.filter(suits, fn x -> elem(x, 1) >= 5 end)) do
      {suit, _} -> suit
      _ -> :none
    end
    
    hand
      |> Enum.sort_by(&(&1.number), &(&1 >= &2))
      |> filter_suit(suit)
      |> Enum.uniq_by(fn x -> x.number end)
      |> Enum.any?(fn x -> check_straight(x,filter_suit(hand, suit)) end)
  end

  def filter_suit(hand, suit) do
    Enum.filter(hand, fn card -> card.suit == suit end)
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
    Enum.count(number, fn x -> elem(x, 1) == 2 end) >= 2
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
