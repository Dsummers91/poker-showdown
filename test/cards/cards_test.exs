defmodule CardsTest do
  use ExUnit.Case
  alias Game.Cards
  doctest Showdown


  test "greets the world" do
    assert Cards.return_suit() == :hearts
  end
end
