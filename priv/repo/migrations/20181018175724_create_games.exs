defmodule Showdown.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :players, :integer
      add :round, :string, null: false
      add :deck_hash, :string, null: false
      add :starting_block, :integer, null: false

      timestamps()
    end

  end
end
