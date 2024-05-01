defmodule Viduss.Repo do
  use Ecto.Repo,
    otp_app: :viduss,
    adapter: Ecto.Adapters.Postgres
end
