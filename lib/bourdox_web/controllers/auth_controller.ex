defmodule BourdoxWeb.AuthController do
  @moduledoc false
  use BourdoxWeb, :controller

  alias BourdoxCore.Accounts.Users
  alias BourdoxCore.Accounts.UserTokens

  action_fallback BourdoxWeb.FallbackController

  @doc false
  def signin(conn, %{"credentials" => user_credentials}) do
    with {:ok, user} <- Users.authenticate_user(user_credentials),
         {:ok, %{token: access}} <- UserTokens.generate_user_token(user, "access"),
         {:ok, %{token: refresh}} <- UserTokens.generate_user_token(user, "refresh") do
      render(conn, :index, tokens: %{access: access, refresh: refresh})
    end
  end

  @doc false
  def signup(conn, %{"user" => user_params}) do
    with {:ok, user} <- Users.create_user(user_params),
         {:ok, %{token: access}} <- UserTokens.generate_user_token(user, "access"),
         {:ok, %{token: refresh}} <- UserTokens.generate_user_token(user, "refresh"),
         {:ok, %{token: confirm}} <- UserTokens.generate_user_token(user, "confirm_account") do
      # UserEmails.send_instructions(:confirm_email, user, ~p"/confirm-email?code=#{confirm}")

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> put_resp_header("location", ~p"/api/confirm-account?token=#{confirm}")
      |> render(:index, tokens: %{access: access, refresh: refresh})
    end
  end

  @doc false
  def refresh(conn, %{"token" => token}) do
    with {:ok, user_token} <- UserTokens.validate_user_token(token, "refresh"),
         {:ok, %{token: access}} <- UserTokens.generate_user_token(user_token.user, "access"),
         {:ok, %{token: refresh}} <- UserTokens.generate_user_token(user_token.user, "refresh"),
         {:ok, _user_token} <- UserTokens.revoke_user_token(user_token) do
      render(conn, :index, tokens: %{access: access, refresh: refresh})
    end
  end

  @doc false
  def confirm_account(conn, %{"token" => token}) do
    with {:ok, user_token} <- UserTokens.validate_user_token(token, "confirm_account"),
         {:ok, _user} <- Users.update_user(user_token.user, %{is_inactive: false}),
         {:ok, _user_token} <- UserTokens.revoke_user_token(user_token) do
      send_resp(conn, :ok, "")
    end
  end
end
