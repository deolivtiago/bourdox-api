defmodule BourdoxWeb.UserJSONTest do
  use BourdoxWeb.ConnCase, async: true

  alias BourdoxCore.Accounts.UsersFixtures
  alias BourdoxWeb.UserJSON

  setup do
    {:ok, user: UsersFixtures.build_user()}
  end

  describe "renders" do
    test "a list of users", %{user: user} do
      assert %{data: [user_data]} = UserJSON.index(%{users: [user]})

      assert user_data.id == user.id
      assert user_data.first_name == user.first_name
      assert user_data.last_name == user.last_name
      assert user_data.email == user.email
      assert user_data.role == user.role
      assert user_data.is_inactive == user.is_inactive
    end

    test "a single user", %{user: user} do
      assert %{data: user_data} = UserJSON.show(%{user: user})

      assert user_data.id == user.id
      assert user_data.first_name == user.first_name
      assert user_data.last_name == user.last_name
      assert user_data.email == user.email
      assert user_data.role == user.role
      assert user_data.is_inactive == user.is_inactive
    end
  end
end
