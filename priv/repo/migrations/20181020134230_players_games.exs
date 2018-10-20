defmodule Showdown.Repo.Migrations.PlayersGames do
  use Ecto.Migration

  def change do
    create table(:players_games) do
      add :player_id, references(:players)
      add :game_id, references(:games)
    end

    create unique_index(:players_games, [:game_id, :player_id])
  end

end
