defmodule BourdoxCore.Repo do
  use Ecto.Repo,
    otp_app: :bourdox,
    adapter: Ecto.Adapters.Postgres
end
