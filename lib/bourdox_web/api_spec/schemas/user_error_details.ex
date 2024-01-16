defmodule BourdoxWeb.ApiSpec.Schemas.UserErrorDetails do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "UserErrorDetails",
    description: "Not found error",
    type: :object,
    properties: %{
      email: %Schema{
        type: :array,
        description: "List of errors"
      }
    },
    example: %{
      "email" => [
        "has already been taken"
      ]
    }
  })
end
