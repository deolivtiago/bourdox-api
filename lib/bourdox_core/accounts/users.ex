defmodule BourdoxCore.Accounts.Users do
  @moduledoc """
  The Accounts.Users context.
  """

  alias BourdoxCore.Accounts.Users.User
  alias BourdoxCore.Repo

  @doc """
  Returns the list of users

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users, do: Repo.all(User)

  @doc """
  Gets a single user

  ## Examples

      iex> get_user(field, value)
      {:ok, %User{}}

      iex> get_user(field, bad_value)
      {:error, %Ecto.Changeset{}}

  """
  def get_user(:id, id), do: get_by(:id, id)
  def get_user(:email, email), do: get_by(:email, email)

  defp get_by(key, value) do
    User
    |> Repo.get_by!([{key, value}])
    |> then(&{:ok, &1})
  rescue
    Ecto.Query.CastError ->
      handle_error(key, value, "is invalid")

    Ecto.NoResultsError ->
      handle_error(key, value, "not found")

    error ->
      reraise error, __STACKTRACE__
  end

  defp handle_error(key, value, message) do
    %User{}
    |> Ecto.Changeset.change([{key, value}])
    |> Ecto.Changeset.add_error(key, message)
    |> then(&{:error, &1})
  end

  @doc """
  Creates a user

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user), do: Repo.delete(user)

  @doc """
  Authenticates an user

  ## Examples

      iex> authenticate_user(%{field: value})
      {:ok, %User{}}

      iex> authenticate_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def authenticate_user(user_credentials) do
    with {:ok, %{email: email, password: password}} <- User.validate_credentials(user_credentials) do
      user = Repo.get_by(User, email: email)

      if valid_credentials?(user, password) do
        {:ok, user}
      else
        handle_error(:email, email, "invalid credentials")
      end
    end
  end

  defp valid_credentials?(%User{} = user, password) when is_binary(password) do
    Argon2.verify_pass(password, user.password)
  end

  defp valid_credentials?(_user, _password), do: Argon2.no_user_verify()
end
