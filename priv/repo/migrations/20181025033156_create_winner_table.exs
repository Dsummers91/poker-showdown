defmodule Showdown.Repo.Migrations.AddBetField do
  use Ecto.Migration

  def change do
    create table(:game_bets) do
      add :game_id, references(:games)
      add :player_id, references(:owners)
      add :user_id, references(:users)
      add :bet_amount, :integer
    end
  end
end
