defmodule Showdown.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :address, :string
    field :balance, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:address, :balance])
    |> validate_required([:address, :balance])
  end
end
