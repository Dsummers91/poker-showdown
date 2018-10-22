defmodule Showdown.Seeds do

  def call do
    if length(Showdown.Casino.list_cards) != 52 do
      Showdown.Repo.delete_all(Showdown.Card)
      for suit <- [:hearts, :clubs, :diamonds, :spades], num <- 2..14 do
        Showdown.Repo.insert!(%Showdown.Card{number: num, suit: Atom.to_string(suit)})
      end
    end
    if length(Showdown.Casino.list_owners) != 5 do
      Showdown.Repo.delete_all(Showdown.Owner)
      for owner <- [:player1, :player2, :player3, :player4, :board] do
        Showdown.Repo.insert!(%Showdown.Owner{name: to_string(owner)})
      end
    end

  #  %{starting_block: 1000, deck_hash: "0x", round: "flop"}
   #  |> Map.take([:round, :starting_block, :deck_hash])
    # |> Map.put_new(:round, "preflop")
     #|> (&(Showdown.Game.changeset(%Showdown.Game{}, &1))).()
     #|> Showdown.Repo.insert

  end

end
