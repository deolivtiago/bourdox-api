defmodule BourdoxCore.Accounts.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BourdoxCore.Accounts.Users` context.
  """
  alias BourdoxCore.Accounts.Users.User
  alias BourdoxCore.Repo

  @doc """
  Generate fake user attrs

    ## Examples

      iex> user_attrs(%{field: value})
      %{field: value, ...}

  """
  def user_attrs(attrs \\ %{}) do
    Map.new()
    |> Map.put(:id, Faker.UUID.v4())
    |> Map.put(:first_name, Faker.Person.first_name())
    |> Map.put(:last_name, Faker.Person.last_name())
    |> Map.put(:email, Faker.Internet.email())
    |> Map.put(:password, "Password@123")
    |> Map.put(:role, :admin)
    |> Map.put(:is_inactive, false)
    |> Map.put(:inserted_at, Faker.DateTime.backward(366))
    |> Map.put(:updated_at, DateTime.utc_now())
    |> Map.merge(attrs)
  end

  @doc """
  Builds a fake user

    ## Examples

      iex> build_user(%{field: value})
      %User{field: value, ...}

  """
  def build_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(user_attrs(attrs))
    |> Ecto.Changeset.apply_action!(nil)
  end

  @doc """
  Inserts a fake user

    ## Examples

      iex> insert_user(%{field: value})
      %User{field: value, ...}

  """
  def insert_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(user_attrs(attrs))
    |> Repo.insert!()
  end
end
