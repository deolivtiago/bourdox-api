defmodule BourdoxWeb.AuthJSON do
  @moduledoc false

  @doc """
  Renders auth tokens
  """
  def index(%{tokens: tokens}), do: %{data: %{tokens: tokens}}
  def index(%{user: user}), do: BourdoxWeb.UserJSON.show(%{user: user})
end
