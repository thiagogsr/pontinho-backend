defmodule Pontinho.Repo do
  use Ecto.Repo,
    otp_app: :pontinho,
    adapter: Ecto.Adapters.Postgres
end
