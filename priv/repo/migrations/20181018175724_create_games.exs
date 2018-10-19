defmodule Showdown.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :players, :integer
      add :board, :integer
      add :round, :string
      add :board_hash, :string
      add :starting_block, :integer

      timestamps()
    end

  end
end
