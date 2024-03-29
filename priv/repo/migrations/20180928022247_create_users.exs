defmodule Showdown.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :address, :string
      add :balance, :integer
      timestamps()
    end

    create unique_index(:users, [:address])
  end
end
