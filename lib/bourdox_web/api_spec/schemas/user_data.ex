defmodule BourdoxWeb.ApiSpec.Schemas.UserData do
  require OpenApiSpex

  alias BourdoxWeb.ApiSpec.Schemas.UserAttrs

  OpenApiSpex.schema(%{
    title: "UserData",
    description: "User data",
    type: :object,
    properties: %{data: UserAttrs},
    example: %{
      "data" => %{
        "id" => "11c4a366-f12c-43f1-af4a-d591fdfc9144",
        "first_name" => "John",
        "last_name" => "Doe",
        "email" => "john.doe@mail.com",
        "role" => "admin",
        "is_inactive" => true
      }
    }
  })
end
