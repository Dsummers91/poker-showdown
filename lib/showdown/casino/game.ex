defmodule Showdown.Game do
  use Ecto.Schema
  import Ecto.Changeset


  schema "games" do
    field :players, :integer
    field :board, :integer
    field :round, :string
    field :board_hash, :string
    field :starting_block, :integer

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:players, :board, :round, :board_hash, :starting_block])
    |> validate_required([:players])
  end
end
