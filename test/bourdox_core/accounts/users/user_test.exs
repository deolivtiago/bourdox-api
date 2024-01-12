defmodule BourdoxCore.Accounts.Users.UserTest do
  use BourdoxCore.DataCase, async: true

  alias BourdoxCore.Accounts.Users.User
  alias BourdoxCore.Accounts.UsersFixtures
  alias Ecto.Changeset

  setup do
    {:ok, attrs: UsersFixtures.user_attrs()}
  end

  describe "changeset/2 returns a valid changeset" do
    test "when first first name is valid", %{attrs: attrs} do
      changeset = User.changeset(%User{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert changes.first_name == attrs.first_name
    end

    test "when last first name is valid", %{attrs: attrs} do
      changeset = User.changeset(%User{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert changes.last_name == attrs.last_name
    end

    test "when email is valid", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, String.upcase(attrs.email))

      changeset = User.changeset(%User{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert changes.email == String.downcase(attrs.email)
    end

    test "when password is valid", %{attrs: attrs} do
      changeset = User.changeset(%User{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert Argon2.verify_pass(attrs.password, changes.password)
    end

    test "when role is valid", %{attrs: attrs} do
      changeset = User.changeset(%User{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert changes.role == attrs.role
    end

    test "when active flag is valid", %{attrs: attrs} do
      changeset = User.changeset(%User{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert changes.is_inactive == attrs.is_inactive
    end
  end

  describe "changeset/2 returns an invalid changeset" do
    test "when first name is too short", %{attrs: attrs} do
      attrs = Map.put(attrs, :first_name, "?")

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.first_name, "should be at least 2 character(s)")
    end

    test "when first name is null", %{attrs: attrs} do
      attrs = Map.put(attrs, :first_name, nil)

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.first_name, "can't be blank")
    end

    test "when first name is not given", %{attrs: attrs} do
      attrs = Map.delete(attrs, :first_name)

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.first_name, "can't be blank")
    end

    test "when first name is empty", %{attrs: attrs} do
      attrs = Map.put(attrs, :first_name, "")

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.first_name, "can't be blank")
    end

    test "when last name is too short", %{attrs: attrs} do
      attrs = Map.put(attrs, :last_name, "?")

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.last_name, "should be at least 2 character(s)")
    end

    test "when email is null", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, nil)

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "can't be blank")
    end

    test "when email is not given", %{attrs: attrs} do
      attrs = Map.delete(attrs, :email)

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "can't be blank")
    end

    test "when email is empty", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "")

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "can't be blank")
    end

    test "when email has invalid format", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "email.invalid")

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has invalid format")
    end

    test "when email is too short", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, "@")

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "should be at least 3 character(s)")
    end

    test "when password is too short", %{attrs: attrs} do
      attrs = Map.put(attrs, :password, "?")

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.password, "should be at least 6 character(s)")
    end

    test "when password is null", %{attrs: attrs} do
      attrs = Map.put(attrs, :password, nil)

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.password, "can't be blank")
    end

    test "when password is not given", %{attrs: attrs} do
      attrs = Map.delete(attrs, :password)

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.password, "can't be blank")
    end

    test "when password is empty", %{attrs: attrs} do
      attrs = Map.put(attrs, :password, "")

      changeset = User.changeset(%User{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.password, "can't be blank")
    end
  end

  describe "validate_credentials/1 returns" do
    test "ok when credentials are valid" do
      credentials = %{email: "some@mail.com", password: "secret"}

      assert {:ok, user} = User.validate_credentials(credentials)

      assert user.email == credentials.email
      assert user.password == credentials.password
    end

    test "error when credentials are invalid" do
      credentials = %{email: "invalid_email", password: nil}

      assert {:error, changeset} = User.validate_credentials(credentials)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has invalid format")
      assert Enum.member?(errors.password, "can't be blank")
    end
  end
end
