defmodule BourdoxCore.Accounts.Users.User do
  @moduledoc """
  Database schema for users
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_attrs ~w(first_name email password role is_inactive)a
  @optional_attrs ~w(last_name)a

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, redact: true

    field :role, Ecto.Enum, values: [:user, :admin], default: :user
    field :is_inactive, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:id, name: :users_pkey)
    |> unique_constraint(:email)
    |> validate_length(:first_name, min: 2, max: 255)
    |> validate_length(:last_name, min: 2, max: 255)
    |> validate_length(:email, min: 3, max: 255)
    |> validate_length(:password, min: 6, max: 255)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/^[a-z0-9\-._+&#$?!]+[@][a-z0-9\-._+]+$/)
    |> update_change(:password, &Argon2.hash_pwd_salt/1)
  end

  @doc """
  Validates user credentials

  ## Examples

      iex> validate_credentials(valid_credentials)
      {:ok, %User{}}

      iex> validate_credentials(invalid_credentials)
      {:error, %Ecto.Changeset{}}

  """
  def validate_credentials(credentials \\ %{}) do
    %User{}
    |> cast(credentials, ~w(email password)a)
    |> validate_required(~w(email password)a)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/^[a-z0-9\-._+&#$?!]+[@][a-z0-9\-._+]+$/)
    |> apply_action(:validate)
  end
end
