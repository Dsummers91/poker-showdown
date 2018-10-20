defmodule Showdown.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do

      timestamps()
    end

  end
end
