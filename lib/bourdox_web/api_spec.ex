defmodule BourdoxWeb.ApiSpec do
  @behaviour OpenApiSpex.OpenApi

  @doc """

      # Example


      %OpenApiSpex.OpenApi{
        openapi: "3.0",
        info: %OpenApiSpex.Info{
          title: "Swagger Petstore",
          description: "A sample API that uses a petstore as an example to demonstrate features in the swagger-2.0 specification",
          termsOfService: "http://swagger.io/terms/",
          contact: %OpenApiSpex.Contact{
            name: "Swagger API Team",
            url: nil,
            email: nil,
            extensions: nil
          },
          license: %OpenApiSpex.License{name: "MIT", url: nil, extensions: nil},
          version: "1.0.0",
          extensions: nil
        },
        servers: [],
        paths: %{
          "/pets" => %OpenApiSpex.PathItem{
            "$ref": nil,
            summary: nil,
            description: nil,
            get: %OpenApiSpex.Operation{
              tags: [],
              summary: nil,
              description: "Returns all pets from the system that the user has access to",
              externalDocs: nil,
              operationId: "findPets",
              parameters: [
                %OpenApiSpex.Parameter{
                  name: :tags,
                  in: :query,
                  description: "tags to filter by",
                  required: false,
                  deprecated: nil,
                  allowEmptyValue: nil,
                  style: nil,
                  explode: nil,
                  allowReserved: nil,
                  schema: nil,
                  example: nil,
                  examples: nil,
                  content: nil,
                  extensions: nil
                },
                %OpenApiSpex.Parameter{
                  name: :limit,
                  in: :query,
                  description: "maximum number of results to return",
                  required: false,
                  deprecated: nil,
                  allowEmptyValue: nil,
                  style: nil,
                  explode: nil,
                  allowReserved: nil,
                  schema: nil,
                  example: nil,
                  examples: nil,
                  content: nil,
                  extensions: nil
                }
              ],
              requestBody: nil,
              responses: %{
                "200" => %OpenApiSpex.Response{
                  description: "pet response",
                  headers: nil,
                  content: nil,
                  links: nil,
                  extensions: nil
                },
                "default" => %OpenApiSpex.Response{
                  description: "unexpected error",
                  headers: nil,
                  content: nil,
                  links: nil,
                  extensions: nil
                }
              },
              callbacks: %{},
              deprecated: false,
              security: nil,
              servers: nil,
              extensions: nil
            },
            put: nil,
            post: %OpenApiSpex.Operation{
              tags: [],
              summary: nil,
              description: "Creates a new pet in the store.  Duplicates are allowed",
              externalDocs: nil,
              operationId: "addPet",
              parameters: [
                %OpenApiSpex.Parameter{
                  name: :pet,
                  in: :body,
                  description: "Pet to add to the store",
                  required: true,
                  deprecated: nil,
                  allowEmptyValue: nil,
                  style: nil,
                  explode: nil,
                  allowReserved: nil,
                  schema: %OpenApiSpex.Reference{"$ref": "#/definitions/NewPet"},
                  example: nil,
                  examples: nil,
                  content: nil,
                  extensions: nil
                }
              ],
              requestBody: nil,
              responses: %{
                "200" => %OpenApiSpex.Response{
                  description: "pet response",
                  headers: nil,
                  content: nil,
                  links: nil,
                  extensions: nil
                },
                "default" => %OpenApiSpex.Response{
                  description: "unexpected error",
                  headers: nil,
                  content: nil,
                  links: nil,
                  extensions: nil
                }
              },
              callbacks: %{},
              deprecated: false,
              security: nil,
              servers: nil,
              extensions: nil
            },
            delete: nil,
            options: nil,
            head: nil,
            patch: nil,
            trace: nil,
            servers: nil,
            parameters: nil,
            extensions: nil
          },
          "/pets/{id}" => %OpenApiSpex.PathItem{
            "$ref": nil,
            summary: nil,
            description: nil,
            get: %OpenApiSpex.Operation{
              tags: [],
              summary: nil,
              description: "Returns a user based on a single ID, if the user does not have access to the pet",
              externalDocs: nil,
              operationId: "findPetById",
              parameters: [
                %OpenApiSpex.Parameter{
                  name: :id,
                  in: :path,
                  description: "ID of pet to fetch",
                  required: true,
                  deprecated: nil,
                  allowEmptyValue: nil,
                  style: nil,
                  explode: nil,
                  allowReserved: nil,
                  schema: nil,
                  example: nil,
                  examples: nil,
                  content: nil,
                  extensions: nil
                }
              ],
              requestBody: nil,
              responses: %{
                "200" => %OpenApiSpex.Response{
                  description: "pet response",
                  headers: nil,
                  content: nil,
                  links: nil,
                  extensions: nil
                },
                "default" => %OpenApiSpex.Response{
                  description: "unexpected error",
                  headers: nil,
                  content: nil,
                  links: nil,
                  extensions: nil
                }
              },
              callbacks: %{},
              deprecated: false,
              security: nil,
              servers: nil,
              extensions: nil
            },
            put: nil,
            post: nil,
            delete: %OpenApiSpex.Operation{
              tags: [],
              summary: nil,
              description: "deletes a single pet based on the ID supplied",
              externalDocs: nil,
              operationId: "deletePet",
              parameters: [
                %OpenApiSpex.Parameter{
                  name: :id,
                  in: :path,
                  description: "ID of pet to delete",
                  required: true,
                  deprecated: nil,
                  allowEmptyValue: nil,
                  style: nil,
                  explode: nil,
                  allowReserved: nil,
                  schema: nil,
                  example: nil,
                  examples: nil,
                  content: nil,
                  extensions: nil
                }
              ],
              requestBody: nil,
              responses: %{
                "204" => %OpenApiSpex.Response{
                  description: "pet deleted",
                  headers: nil,
                  content: nil,
                  links: nil,
                  extensions: nil
                },
                "default" => %OpenApiSpex.Response{
                  description: "unexpected error",
                  headers: nil,
                  content: nil,
                  links: nil,
                  extensions: nil
                }
              },
              callbacks: %{},
              deprecated: false,
              security: nil,
              servers: nil,
              extensions: nil
            },
            options: nil,
            head: nil,
            patch: nil,
            trace: nil,
            servers: nil,
            parameters: nil,
            extensions: nil
          }
        },
        components: nil,
        security: [],
        tags: [],
        externalDocs: nil,
        extensions: nil
      }
  """
  @impl OpenApiSpex.OpenApi
  def spec do
    OpenApiSpex.resolve_schema_modules(%OpenApiSpex.OpenApi{
      servers: [OpenApiSpex.Server.from_endpoint(BourdoxWeb.Endpoint)],
      info: %OpenApiSpex.Info{
        title: "Bourdox Platform API",
        version: to_string(Application.spec(:bourdox, :vsn))
      },
      paths: OpenApiSpex.Paths.from_router(BourdoxWeb.Router)
    })
  end
end
