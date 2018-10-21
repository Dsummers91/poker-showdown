defmodule Showdown.Repo.Migrations.CreateGamesCards do
  use Ecto.Migration

  def change do
    create table(:game_cards) do
      add :game_id, references(:games)
      add :card_id, references(:cards)
      add :owner, :string
    end

  end

end
