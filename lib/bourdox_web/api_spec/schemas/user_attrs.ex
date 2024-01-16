defmodule BourdoxWeb.ApiSpec.Schemas.UserAttrs do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "UserAttrs",
    description: "User attributes",
    type: :object,
    properties: %{
      id: %Schema{
        type: :string,
        description: "User UUID",
        pattern: "00000000-0000-0000-0000-000000000000"
      },
      first_name: %Schema{type: :string, description: "First name"},
      last_name: %Schema{type: :string, description: "Last name"},
      email: %Schema{type: :string, description: "Email address", format: :email},
      role: %Schema{type: :string, description: "User role", enum: ["user", "admin"]},
      is_inactive: %Schema{type: :boolean, description: "Active flag"}
      # inserted_at: %Schema{
      #   type: :string,
      #   description: "Creation timestamp with TZ",
      #   format: :"date-time"
      # },
      # updated_at: %Schema{
      #   type: :string,
      #   description: "Update timestamp with TZ",
      #   format: :"date-time"
      # }
    },
    example: %{
      "id" => "11c4a366-f12c-43f1-af4a-d591fdfc9144",
      "first_name" => "John",
      "last_name" => "Doe",
      "email" => "john.doe@mail.com",
      "role" => "admin",
      "is_inactive" => true
    }
  })
end
