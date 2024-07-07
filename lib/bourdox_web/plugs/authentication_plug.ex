defmodule BourdoxWeb.Plugs.AuthenticationPlug do
  @moduledoc """
  Authentication Plug
  """
  import Plug.Conn

  alias BourdoxCore.Accounts.UserTokens

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, _opts) do
    case verify_auth_token(conn) do
      {:ok, %{user: user}} ->
        assign(conn, :current_user, user)

      _error ->
        send_resp(conn, :unauthorized, "") |> halt()
    end
  end

  defp verify_auth_token(conn) do
    type = token_type(conn.request_path)

    conn
    |> get_req_header("authorization")
    |> List.first("")
    |> String.replace(~r/^Bearer\s/, "")
    |> UserTokens.validate_user_token(type)
  end

  defp token_type(request_path) do
    request_path
    |> String.split("/", trim: true)
    |> Enum.filter(&String.match?(&1, ~r/^refresh$/))
    |> List.first("access")
  end
end
