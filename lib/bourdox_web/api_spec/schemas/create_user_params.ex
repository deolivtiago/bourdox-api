defmodule BourdoxWeb.ApiSpec.Schemas.CreateUserParams do
  require OpenApiSpex

  alias BourdoxWeb.ApiSpec.Schemas.UserParams

  OpenApiSpex.schema(%{
    title: "CreateUserParams",
    description: "Parameters for creating an user",
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
