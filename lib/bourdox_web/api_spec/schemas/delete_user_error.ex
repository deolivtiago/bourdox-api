defmodule BourdoxWeb.ApiSpec.Schemas.DeleteUserError do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "DeleteUserError",
    description: "Errors when deleting an user",
    type: :object,
    properties: %{
      errors: %Schema{
        type: :object,
        description: "Attributes with error"
      }
    },
    example: %{
      "errors" => %{"id" => ["not found"]}
    }
  })
end
