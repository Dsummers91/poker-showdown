defmodule Showdown.AccountsTest do
  use Showdown.DataCase

  alias Showdown.Accounts

  describe "users" do
    alias Showdown.Accounts.User

    @valid_attrs %{address: "some address", balance: 10000}
    @update_attrs %{address: "some updated address"}
    @invalid_attrs %{address: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.address == "some address"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/1 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(%{id: user.id, user: @update_attrs})
      assert %User{} = user
      assert user.address == "some updated address"
    end

    test "update_user/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(%{id: user.id, user: @invalid_attrs})
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "should be able to" do

    end
  end
end
