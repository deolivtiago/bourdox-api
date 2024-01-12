defmodule BourdoxWeb.UserJSON do
  @moduledoc false

  alias BourdoxCore.Accounts.Users.User

  @doc """
  Renders a list of users
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user
  """
  def show(%{user: user}), do: %{data: data(user)}

  defp data(%User{} = user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      is_inactive: user.is_inactive,
      role: user.role
    }
  end
end
