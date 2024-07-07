defmodule BourdoxCore.Accounts.UserTokens.UserToken do
  @moduledoc """
  user token schema
  """
  use Ecto.Schema
  use Joken.Config

  import Ecto.Changeset

  alias __MODULE__
  alias BourdoxCore.Accounts.Users.User

  @host "bourdox"
  @two_days 60 * 60 * 24 * 2
  @two_weeks 60 * 60 * 24 * 7 * 2

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  @token_types ~w(access refresh confirm_account reset_password change_email)
  @uuid_regex ~r/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/

  @required_attrs ~w(id token expiration type user_id)a

  schema "user_tokens" do
    field :token, :string
    field :expiration, :utc_datetime
    field :type, Ecto.Enum, values: Enum.map(@token_types, &String.to_atom/1)

    belongs_to :user, User

    timestamps(type: :utc_datetime, updated_at: false)
  end

  def changeset(%UserToken{} = user_token, attrs \\ %{}) do
    user_token
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
    |> update_change(:user_id, &String.downcase/1)
    |> validate_format(:user_id, @uuid_regex)
    |> update_change(:id, &String.downcase/1)
    |> validate_format(:id, @uuid_regex)
    |> unique_constraint(:id, name: :user_tokens_pkey)
    |> unique_constraint(:token)
    |> assoc_constraint(:user)
  end

  def generate_signed_token(sub, typ) do
    exp = if typ == "refresh", do: current_time() + @two_weeks, else: current_time() + @two_days

    Map.new()
    |> Map.put("sub", String.downcase(sub))
    |> Map.put("typ", typ)
    |> Map.put("exp", exp)
    |> generate_and_sign()
  end

  def validate_signed_token(token, typ) do
    case verify_and_validate(token) do
      {:ok, %{"typ" => ^typ} = claims} -> {:ok, claims}
      {:ok, %{"typ" => typ}} -> {:error, [message: "Invalid token", claim: "typ", claim_val: typ]}
      error -> error
    end
  end

  # def changeset(%UserToken{} = user_token, attrs) do
  #   user_token
  #   |> cast(attrs, ~w(user_id type)a)
  #   |> validate_required(~w(user_id type)a)
  #   |> put_change(:user_id, &String.downcase/1)
  #   |> validate_format(:user_id, @uuid_regex)
  #   |> apply_action!(:validate)
  #   |> generate_signed_token()
  # end

  # defp changeset(attrs) do
  #   %UserToken{}
  #   |> cast(attrs, @required_attrs)
  #   |> validate_required(@required_attrs)
  #   |> put_change(:user_id, &String.downcase/1)
  #   |> validate_format(:user_id, @uuid_regex)
  #   |> unique_constraint(:id, name: :user_tokens_pkey)
  #   |> unique_constraint(:token)
  #   |> assoc_constraint(:user)
  # end

  # defp generate_signed_token(%{valid?: false} = changeset), do: changeset

  # defp generate_signed_token(%{user_id: user_id, type: type}) do
  #   case default_claims(type, user_id) |> generate_and_sign() do
  #     {:ok, token, %{"exp" => exp, "jti" => jti}} ->
  #       Map.new()
  #       |> Map.put(:id, jti)
  #       |> Map.put(:token, token)
  #       |> Map.put(:expiration, DateTime.from_unix!(exp))
  #       |> Map.put(:type, type)
  #       |> Map.put(:user_id, user_id)
  #       |> changeset()

  #     {:error, _reason} ->
  #       %UserToken{}
  #       |> change(%{user_id: user_id, type: type})
  #       |> add_error(:token, "error generating token")
  #       |> then(&{:error, &1})
  #   end
  # end

  # @doc false
  # def changeset(%UserToken{} = user_token, attrs \\ %{}) do
  #   user_token
  #   |> cast(attrs, @required_attrs)
  #   |> validate_required(@required_attrs)
  #   |> put_change(:user_id, &String.downcase/1)
  #   |> validate_format(:user_id, @uuid_regex)
  #   |> unique_constraint(:id, name: :user_tokens_pkey)
  #   |> unique_constraint(:token)
  #   |> assoc_constraint(:user)
  # end

  # @doc """
  # Creates a new user token

  # ## Examples

  #     iex> new("any-uuid", "access")
  #     {:ok, "access-token", %{"sub" => "any-uuid", "typ" => "access"}}

  #     iex> new(nil, "access")
  #     {:error, reason}
  # """

  # def new(sub, type) when match?(@uuid_regex, sub) and type in @token_types do
  #   case default_claims(type, sub) |> generate_and_sign() do
  #     {:ok, token, %{"exp" => exp, "jti" => jti}} ->
  #       Map.new()
  #       |> Map.put(:id, jti)
  #       |> Map.put(:token, token)
  #       |> Map.put(:expiration, DateTime.from_unix!(exp))
  #       |> Map.put(:type, type)
  #       |> Map.put(:user_id, sub)
  #       |> then(&changeset(%UserToken{}, &1))

  #     {:error, _reason} ->
  #       %UserToken{}
  #       |> change(%{sub: sub, type: type})
  #       |> add_error(:token, "error generating token")
  #       |> then(&{:error, &1})
  #   end
  # end

  add_hook(Joken.Hooks.RequiredClaims, ~w(jti typ sub exp)a)

  @impl true
  def token_config do
    default_claims(skip: [:jti], iss: @host, aud: @host, default_exp: @two_days)
    |> add_claim("jti", &Ecto.UUID.generate/0, &valid_uuid?/1)
    |> add_claim("typ", nil, &valid_type?/1)
    |> add_claim("sub", nil, &valid_uuid?/1)
  end

  defp valid_uuid?(id) when is_binary(id), do: String.match?(id, @uuid_regex)

  defp valid_type?(typ), do: Enum.member?(@token_types, typ)
end
