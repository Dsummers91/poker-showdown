defmodule Showdown.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :address, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:address])
    |> validate_required([:address])
  end
end
