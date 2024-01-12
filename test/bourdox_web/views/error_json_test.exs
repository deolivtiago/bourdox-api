defmodule BourdoxWeb.ErrorJSONTest do
  use BourdoxWeb.ConnCase, async: true

  alias BourdoxWeb.ErrorJSON

  test "renders 500" do
    assert ErrorJSON.render("500.json", %{}) == %{errors: %{detail: "Internal Server Error"}}
  end
end
