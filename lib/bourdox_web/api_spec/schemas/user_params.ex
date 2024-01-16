defmodule BourdoxWeb.ApiSpec.Schemas.UserParams do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "UserParams",
    description: "User params",
    type: :object,
    properties: %{
      first_name: %Schema{type: :string, description: "First name"},
      last_name: %Schema{type: :string, description: "Last name"},
      email: %Schema{type: :string, description: "Email address", format: :email},
      password: %Schema{type: :string, description: "User password"},
      role: %Schema{type: :string, description: "User role", enum: ["user", "admin"]},
      is_inactive: %Schema{type: :boolean, description: "Active flag"}
    },
    required: [:first_name, :email, :password],
    example: %{
      "first_name" => "John",
      "last_name" => "Doe",
      "email" => "john.doe@mail.com",
      "password" => "JohnDoe@123",
      "role" => "admin",
      "is_inactive" => true
    }
  })
end
