defmodule BourdoxWeb.UserController do
  @moduledoc false
  use BourdoxWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BourdoxWeb.ApiSpec.Schemas.CreateUserError
  alias BourdoxWeb.ApiSpec.Schemas.UpdateUserError
  alias BourdoxWeb.ApiSpec.Schemas.DeleteUserError
  alias BourdoxWeb.ApiSpec.Schemas.UpdateUserParams
  alias BourdoxWeb.ApiSpec.Schemas.CreateUserParams
  alias BourdoxWeb.ApiSpec.Schemas.UserData
  alias BourdoxWeb.ApiSpec.Schemas.NotFoundError
  alias BourdoxWeb.ApiSpec.Schemas.InternalServerError

  alias BourdoxCore.Accounts.Users

  action_fallback BourdoxWeb.FallbackController

  tags ["users"]

  operation :index,
    summary: "List users",
    responses: [
      ok: {"User data", "application/json", UserData},
      unprocessable_entity: {"Unprocessable error", "application/json", DeleteUserError},
      not_found: {"Not found error", "application/json", NotFoundError},
      internal_server_error: {"Server error", "application/json", InternalServerError}
    ]

  @doc false
  def index(conn, _params) do
    users = Users.list_users()

    render(conn, :index, users: users)
  end

  operation :create,
    summary: "Create an user",
    request_body: {"Create user params", "application/json", CreateUserParams},
    responses: [
      created: {"User data", "application/json", UserData},
      unprocessable_entity: {"Unprocessable error", "application/json", CreateUserError},
      not_found: {"Not found error", "application/json", NotFoundError},
      internal_server_error: {"Server error", "application/json", InternalServerError}
    ]

  @doc false
  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  operation :show,
    summary: "Show an user",
    parameters: [
      id: [
        in: :path,
        description: "User UUID",
        type: :string,
        example: "11c4a366-f12c-43f1-af4a-d591fdfc9144",
        required: true
      ]
    ],
    responses: [
      ok: {"User data", "application/json", UserData},
      unprocessable_entity: {"Unprocessable error", "application/json", DeleteUserError},
      not_found: {"Not found error", "application/json", NotFoundError},
      internal_server_error: {"Server error", "application/json", InternalServerError}
    ]

  @doc false
  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Users.get_user(:id, id) do
      render(conn, :show, user: user)
    end
  end

  operation :update,
    summary: "Update user",
    parameters: [
      id: [
        in: :path,
        description: "User UUID",
        type: :string,
        example: "11c4a366-f12c-43f1-af4a-d591fdfc9144",
        required: true
      ]
    ],
    request_body: {"User params", "application/json", UpdateUserParams, required: true},
    responses: [
      ok: {"User data", "application/json", UserData},
      unprocessable_entity: {"Unprocessable error", "application/json", UpdateUserError},
      not_found: {"Not found error", "application/json", NotFoundError},
      internal_server_error: {"Server error", "application/json", InternalServerError}
    ]

  @doc false
  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- Users.get_user(:id, id),
         {:ok, user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  operation :delete,
    summary: "Delete user",
    parameters: [
      id: [
        in: :path,
        description: "User UUID",
        type: :string,
        example: "11c4a366-f12c-43f1-af4a-d591fdfc9144",
        required: true
      ]
    ],
    responses: [
      no_content: "No content",
      unprocessable_entity: {"Unprocessable error", "application/json", DeleteUserError},
      not_found: {"Not found error", "application/json", NotFoundError},
      internal_server_error: {"Server error", "application/json", InternalServerError}
    ]

  @doc false
  def delete(conn, %{"id" => id}) do
    with {:ok, user} <- Users.get_user(:id, id),
         {:ok, _user} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
