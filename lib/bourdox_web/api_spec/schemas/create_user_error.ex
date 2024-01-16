defmodule BourdoxWeb.ApiSpec.Schemas.CreateUserError do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "CreateUserError",
    description: "Errors when creating an user",
    type: :object,
    properties: %{
      errors: %Schema{
        type: :object,
        description: "Attributes with error"
      }
    },
    example: %{
      "errors" => %{"email" => ["has already been taken"], "first_name" => ["is invalid"]}
    }
  })
end
