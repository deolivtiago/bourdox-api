defmodule BourdoxWeb.Router do
  use BourdoxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BourdoxWeb.Plugs.AuthenticationPlug
  end

  scope "/api", BourdoxWeb do
    pipe_through :api

    post "/signup", AuthController, :signup
    post "/signin", AuthController, :signin
    get "/refresh", AuthController, :refresh
    get "/confirm-account", AuthController, :confirm_account
  end

  scope "/api", BourdoxWeb do
    pipe_through [:api, :auth]

    get "/me", UserController, :me

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
