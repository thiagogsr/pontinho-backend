defmodule Pontinho.Repo do
  use Ecto.Repo,
    otp_app: :pontinho,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the DATABASE_URL environment variable.
  """
  def init(_, opts) do
    if database_url = System.get_env("DATABASE_URL") do
      pool_size_env = System.get_env("POOL_SIZE")
      pool_size = if pool_size_env, do: String.to_integer(pool_size_env), else: opts[:pool_size]

      opts =
        opts
        |> Keyword.put(:url, database_url)
        |> Keyword.put(:pool_size, pool_size)

      {:ok, opts}
    else
      {:ok, opts}
    end
  end
end
