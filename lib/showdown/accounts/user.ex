defmodule Showdown.Accounts.User do
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
    |> validate_required([:address])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
