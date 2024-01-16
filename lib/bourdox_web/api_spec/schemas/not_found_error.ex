defmodule BourdoxWeb.ApiSpec.Schemas.NotFoundError do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "NotFoundError",
    description: "Not found error",
    type: :object,
    properties: %{
      detail: %Schema{
        type: :string,
        description: "Default error message"
      }
    },
    example: %{
      detail: "Not found"
    }
  })
end
