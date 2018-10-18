defmodule Showdown.Seeds do

  def call do
    if length(Showdown.Casino.list_cards) != 52 do
      Showdown.Repo.delete_all(Showdown.Card)
      for suit <- [:hearts, :clubs, :diamonds, :spades], num <- 2..14 do
        Showdown.Repo.insert!(%Showdown.Card{number: num, suit: Atom.to_string(suit)})
      end
    end
  end

end
