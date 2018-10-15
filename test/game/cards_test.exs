defmodule CardsTest do
  use ExUnit.Case
  alias Game.Cards
  doctest Showdown

  @tag :skip
  test "greets the world" do
    assert Cards.return_suit() == :hearts
    assert %Cards{} == :hearts
  end
end
