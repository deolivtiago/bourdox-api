defmodule BourdoxCore.Accounts.UserTokens do
  import Ecto.Query

  alias BourdoxCore.Repo
  alias BourdoxCore.Accounts.UserTokens.UserToken
  alias BourdoxCore.Accounts.Users.User

  @token_types ~w(access refresh confirm_account reset_password change_email)

  @doc """
  Creates a user

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def generate_user_token(%User{} = user, type) when type in @token_types do
    case UserToken.generate_signed_token(user.id, type) do
      {:ok, token, %{"exp" => exp, "jti" => id}} ->
        Map.new()
        |> Map.put(:id, id)
        |> Map.put(:token, token)
        |> Map.put(:expiration, DateTime.from_unix!(exp))
        |> Map.put(:type, type)
        |> Map.put(:user_id, user.id)
        |> create_user_token()

      {:error, _reason} ->
        handle_error(:token, type, "signing failure")
    end
  end

  def validate_user_token(token, type) when type in @token_types do
    with {:ok, %{"jti" => id}} <- UserToken.validate_signed_token(token, type),
         {:ok, user_token} <- get_user_token(:id, id) do
      {:ok, user_token}
    else
      _error ->
        handle_error(:token, token, "is invalid")
    end
  end

  defp create_user_token(attrs) do
    changeset = UserToken.changeset(%UserToken{}, attrs)

    with {:ok, user_token} <- Repo.insert(changeset) do
      user_token
      |> Repo.preload(:user)
      |> then(&{:ok, &1})
    end
  end

  defp get_user_token(:id, id), do: get_by(:id, id)

  defp get_by(key, value) do
    query =
      from ut in UserToken,
        where: ut.expiration > ^DateTime.utc_now(:second)

    query
    |> Repo.get_by!([{key, value}])
    |> Repo.preload(:user)
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
    %UserToken{}
    |> Ecto.Changeset.change([{key, value}])
    |> Ecto.Changeset.add_error(key, message)
    |> then(&{:error, &1})
  end

  def revoke_user_token(%UserToken{} = user_token) do
    with {:ok, user_token} <- Repo.delete(user_token) do
      user_token
      |> Repo.preload(:user)
      |> then(&{:ok, &1})
    end
  end
end
