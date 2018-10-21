defmodule Showdown.Card do
  use Ecto.Schema
  import Ecto.Changeset


  schema "cards" do
    field :number, :integer
    field :suit, :string

    has_many :games, Showdown.GameCards


    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:suit, :number])
    |> validate_required([:suit, :number])
  end
end
