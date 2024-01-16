defmodule BourdoxWeb.Router do
  use BourdoxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: BourdoxWeb.ApiSpec
  end

  scope "/" do
    pipe_through :api

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/openapi"
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api", BourdoxWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:bourdox, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
