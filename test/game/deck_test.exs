defmodule DeckTest do
  use Showdown.DataCase
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

  test "should get deck" do
    deck = Showdown.Casino.list_cards()
    assert(length(deck) == 52)
  end

  test "Should not include cards given" do
    {:ok, game} = Showdown.Casino.create_game(%{deck_hash: "0x", starting_block: 0})
    gc = %Showdown.GameCards{} |> Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:card, Showdown.Repo.get(Showdown.Card, 1))
    gc = gc |> Ecto.Changeset.put_assoc(:game, Showdown.Repo.get(Showdown.Game, game.id))
    gc = gc |> Ecto.Changeset.put_assoc(:owner, Showdown.Repo.get(Showdown.Owner, 1)) |> Showdown.Repo.insert!

    game = Showdown.Repo.get(Showdown.Game, game.id)
            |> Repo.preload([cards: [:card, :owner]])
            |> Game.Deck.get_deck
    assert length(game.deck) == 51
  end
end
