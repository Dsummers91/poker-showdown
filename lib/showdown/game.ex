defmodule Showdown.Game do
  use Ecto.Schema
  import Ecto.Changeset


  schema "games" do
    field :board, :integer
    field :board_hash, :string
    field :players, :integer
    field :round, :string
    field :starting_block, :integer

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:players, :board, :round, :board_hash, :starting_block])
    |> validate_required([:players, :board, :round, :board_hash, :starting_block])
  end
end
