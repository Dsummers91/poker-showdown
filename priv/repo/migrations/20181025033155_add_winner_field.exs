defmodule Showdown.Repo.Migrations.AddWinnerField do
  use Ecto.Migration

  def change do
    create table(:game_winners) do
      add :game_id, references(:games)
      add :winner_id, references(:owners)
      add :prize_pool, :integer
    end
  end
end
