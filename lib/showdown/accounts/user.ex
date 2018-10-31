defmodule Showdown.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    @desc "Users ethereum address"
    field :address, :string
    @desc "Users current balance within state channel"
    field :balance, :integer
    #@desc "The nonce increments every successful login attempt"
    #field :nonce, :integer

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
