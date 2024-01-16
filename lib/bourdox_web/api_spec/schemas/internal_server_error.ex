defmodule BourdoxWeb.ApiSpec.Schemas.InternalServerError do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "InternalServerError",
    description: "Internal server error",
    type: :object,
    properties: %{
      detail: %Schema{
        type: :string,
        description: "Default error message"
      }
    },
    example: %{
      detail: "Internal server error"
    }
  })
end
