defmodule BourdoxWeb.ApiSpec.Schemas.UpdateUserError do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "UpdateUserError",
    description: "Errors when updating an user",
    type: :object,
    properties: %{
      errors: %Schema{
        type: :object,
        description: "Attributes with error"
      }
    },
    example: %{
      "errors" => %{
        "id" => ["not found"],
        "email" => ["has already been taken"],
        "first_name" => ["is invalid"]
      }
    }
  })
end
