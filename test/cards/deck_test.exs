defmodule DeckTest do
  use ExUnit.Case
  alias Ethereumex.HttpClient
  alias Game.Deck
  alias Game.Cards
  require Logger
  doctest Showdown


  test "create a Deck" do
    assert length(Deck.new()) == 52
  end

  test "should create string" do
    deck = [%Game.Cards{number: 1, suit: :diamonds}, %Game.Cards{number: 3, suit: :diamonds}]
    assert("1d3d" == Deck.to_string(deck))
  end

  test "should hash deck" do
    deck = Deck.new()
    hash = ExthCrypto.Hash.Keccak.kec(Deck.to_string(deck))
    {removed, deck} = List.pop_at(deck, 0)
    hash2 = ExthCrypto.Hash.Keccak.kec(Deck.to_string(deck))
    assert(hash != hash2) 
    single_hash_0 = ExthCrypto.Hash.Keccak.kec(Deck.to_string([removed]))
    single_hash_1 = ExthCrypto.Hash.Keccak.kec(Deck.to_string([%Game.Cards{number: 2, suit: :hearts}]))
    assert(single_hash_0 == single_hash_1)
  end
end
