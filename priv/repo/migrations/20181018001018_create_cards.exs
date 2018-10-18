defmodule Showdown.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :suit, :string
      add :number, :integer

      timestamps()
    end

  end
end
