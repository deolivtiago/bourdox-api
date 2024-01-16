defmodule BourdoxWeb.ApiSpec.Schemas.UpdateUserParams do
  require OpenApiSpex

  alias BourdoxWeb.ApiSpec.Schemas.UserParams

  OpenApiSpex.schema(%{
    title: "UpdateUserParams",
    description: "Parameters for updating an user",
    type: :object,
    properties: %{user: UserParams},
    required: [:user],
    example: %{
      "user" => %{
        "first_name" => "John",
        "last_name" => "Doe",
        "email" => "john.doe@mail.com",
        "password" => "JohnDoe@123",
        "role" => "admin",
        "is_inactive" => true
      }
    }
  })
end
