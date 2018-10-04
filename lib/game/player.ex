defmodule Game.Player do
	alias Game.Deck
	alias Game.Cards
  
  @player_1_hands [
    %{numbers: [14,14], suits: :offsuit},
    %{numbers: [13,13], suits: :offsuit},
    %{numbers: [12,12], suits: :offsuit},
    %{numbers: [11,11], suits: :offsuit},
    %{numbers: [10,10], suits: :offsuit}
  ]

  @player_2_hands [
    %{numbers: [14,13], suits: :any},
    %{numbers: [14,12], suits: :any},
    %{numbers: [14,11], suits: :any},
    %{numbers: [14,10], suits: :any}
  ]

  @player_3_hands [
    %{numbers: [5, 7], suits: :suited},
    %{numbers: [6, 7], suits: :suited},
    %{numbers: [7, 8], suits: :suited},
    %{numbers: [8, 9], suits: :suited},
    %{numbers: [9, 10], suits: :suited}
  ]

  @player_4_hands [
    %{numbers: [2, 2], suits: :offsuit},
    %{numbers: [3, 3], suits: :offsuit},
    %{numbers: [4, 4], suits: :offsuit},
    %{numbers: [5, 5], suits: :offsuit},
    %{numbers: [6, 6], suits: :offsuit}
  ]

	def possible_hands(player) do
    ranges = case player do
      :player1 -> @player_1_hands 
      :player2 -> @player_2_hands 
      :player3 -> @player_3_hands 
      :player4 -> @player_4_hands
    end

    Enum.flat_map(ranges, fn range ->
      {number, suit} = {range.numbers, range.suits}
      case {number, suit} do
        {_, :offsuit} ->
          [
            [%Game.Cards{number: List.first(number), suit: :clubs}, %Game.Cards{number: List.last(number), suit: :diamonds}],
            [%Game.Cards{number: List.first(number), suit: :hearts}, %Game.Cards{number: List.last(number), suit: :clubs}],
            [%Game.Cards{number: List.first(number), suit: :hearts}, %Game.Cards{number: List.last(number), suit: :diamonds}],
            [%Game.Cards{number: List.first(number), suit: :hearts}, %Game.Cards{number: List.last(number), suit: :spades}],
            [%Game.Cards{number: List.first(number), suit: :spades}, %Game.Cards{number: List.last(number), suit: :club}],
            [%Game.Cards{number: List.first(number), suit: :spades}, %Game.Cards{number: List.last(number), suit: :diamonds}],
          ]
        {_, :suited} -> 
          [
            [%Game.Cards{number: List.first(number), suit: :clubs}, %Game.Cards{number: List.last(number), suit: :clubs}],
            [%Game.Cards{number: List.first(number), suit: :diamonds}, %Game.Cards{number: List.last(number), suit: :diamonds}],
            [%Game.Cards{number: List.first(number), suit: :hearts}, %Game.Cards{number: List.last(number), suit: :hearts}],
            [%Game.Cards{number: List.first(number), suit: :spades}, %Game.Cards{number: List.last(number), suit: :spades}],
          ]
        {_, :any} -> 
          [

            [%Game.Cards{number: List.first(number), suit: :clubs}, %Game.Cards{number: List.last(number), suit: :clubs}],
            [%Game.Cards{number: List.first(number), suit: :clubs}, %Game.Cards{number: List.last(number), suit: :diamonds}],
            [%Game.Cards{number: List.first(number), suit: :diamonds}, %Game.Cards{number: List.last(number), suit: :diamonds}],
            [%Game.Cards{number: List.first(number), suit: :hearts}, %Game.Cards{number: List.last(number), suit: :clubs}],
            [%Game.Cards{number: List.first(number), suit: :hearts}, %Game.Cards{number: List.last(number), suit: :diamonds}],
            [%Game.Cards{number: List.first(number), suit: :hearts}, %Game.Cards{number: List.last(number), suit: :hearts}],
            [%Game.Cards{number: List.first(number), suit: :hearts}, %Game.Cards{number: List.last(number), suit: :spades}],
            [%Game.Cards{number: List.first(number), suit: :spades}, %Game.Cards{number: List.last(number), suit: :club}],
            [%Game.Cards{number: List.first(number), suit: :spades}, %Game.Cards{number: List.last(number), suit: :diamonds}],
            [%Game.Cards{number: List.first(number), suit: :spades}, %Game.Cards{number: List.last(number), suit: :spades}],
          ]
          _ -> [%Cards{number: number, suit: suit}]
      end
    end)
  end
end
