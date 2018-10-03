defmodule DeckTest do
  use ExUnit.Case
  alias Game.Deck
  alias Game.Cards
  doctest Showdown


  test "create a Deck" do
    assert Deck.new() == [2]
  end

end
