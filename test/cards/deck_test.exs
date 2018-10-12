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

  test "should hash deck" do
    deck = Deck.new()
    {:ok, hash} = HttpClient.web3_sha3(deck)
    assert(hash == "0xa86d54e9aab41ae5e520ff0062ff1b4cbd0b2192bb01080a058bb170d84e6457")
    {removed, deck} = List.pop_at(deck, 0)
    {:ok, hash} = HttpClient.web3_sha3(deck)
    assert(hash != "0xa86d54e9aab41ae5e520ff0062ff1b4cbd0b2192bb01080a058bb170d84e6457")
    single_hash_0 = HttpClient.web3_sha3([removed])
    single_hash_1 = HttpClient.web3_sha3(["%Game.Cards{number: 2, suit: :hearts}"])
    assert(single_hash_0 == single_hash_1)
  end
end
