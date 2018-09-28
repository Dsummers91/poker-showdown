defmodule Showdown.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :address, :string

      timestamps()
    end

  end
end
