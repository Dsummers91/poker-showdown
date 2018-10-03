defmodule Game.Hand do
  alias Game.Cards
  alias Game.Deck

  @type player :: :player1 | :player2 | :player3 | :player4
  @type suits :: :suited | :offsuit | :any

  @type hand :: %{ numbers: list(2..14), suits: suits }

  @player_1_hands [
    %{numbers: [14,14], suits: :any},
    %{numbers: [13,13], suits: :any},
    %{numbers: [12,12], suits: :any},
    %{numbers: [11,11], suits: :any},
    %{numbers: [10,10], suits: :any}
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
    %{numbers: [2, 2], suits: :any},
    %{numbers: [3, 3], suits: :any},
    %{numbers: [4, 4], suits: :any},
    %{numbers: [5, 5], suits: :any},
    %{numbers: [6, 6], suits: :any}
  ]

  @doc "create hand for player"
  def create_hand(a, b \\ Deck.new()) 

  @spec create_hand(player, list(Cards.card)) :: {list(Cards.card), list(Cards.card)}
  def create_hand(:player1, deck) do 
    {deck, deck}
  end

  def create_hand(:player2, deck) do 
    {"12", deck}
  end

  @spec select_random_hand(list(list(Cards.card))) :: list(Cards.card) 
  def select_random_hand(hands) do
    hands[0]
  end
end
