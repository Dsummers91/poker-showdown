defmodule Showdown.Repo.Migrations.CreateGamesCards do
  use Ecto.Migration

  def change do
    create table(:game_cards) do
      add :players_games_id, references(:players_games)
      add :card_id, references(:cards)
    end

    create unique_index(:game_cards, [:players_games_id, :card_id])
  end

end
