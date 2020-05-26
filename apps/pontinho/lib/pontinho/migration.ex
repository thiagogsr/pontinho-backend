defmodule Pontinho.Migration do
  @moduledoc """
  Tasks to run migrate and rollback on release
  """

  require Logger

  @repos Application.get_env(:pontinho, :ecto_repos, [])

  @repo_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto_sql
  ]

  def migrate(args \\ []) do
    {:ok, _} = Application.ensure_all_started(:logger)
    Logger.info("[task] running migrate")
    start_repo()

    run_migrations(args)

    Logger.info("[task] finished migrate")
    stop()
  end

  defp start_repo do
    IO.puts("Starting dependencies...")

    Enum.each(@repo_apps, fn app ->
      {:ok, _} = Application.ensure_all_started(app)
    end)

    IO.puts("Starting repos...")
    :ok = Application.load(:pontinho)

    Enum.each(@repos, fn repo ->
      {:ok, _} = repo.start_link(pool_size: 2)
    end)
  end

  def rollback(args \\ []) do
    {:ok, _} = Application.ensure_all_started(:logger)
    Logger.info("[task] running rollback")
    start_repo()

    run_rollback(args)

    Logger.info("[task] finished rollback")
    stop()
  end

  defp stop do
    IO.puts("Stopping...")
    :init.stop()
  end

  defp run_migrations(args) do
    Enum.each(@repos, fn repo ->
      app = Keyword.get(repo.config(), :otp_app)
      IO.puts("Running migrations for #{app}")

      case args do
        ["--step", n] -> migrate(repo, :up, step: String.to_integer(n))
        ["-n", n] -> migrate(repo, :up, step: String.to_integer(n))
        ["--to", to] -> migrate(repo, :up, to: to)
        ["--all"] -> migrate(repo, :up, all: true)
        [] -> migrate(repo, :up, all: true)
      end
    end)
  end

  defp run_rollback(args) do
    Enum.each(@repos, fn repo ->
      app = Keyword.get(repo.config(), :otp_app)
      IO.puts("Running rollback for #{app}")

      case args do
        ["--step", n] -> migrate(repo, :down, step: String.to_integer(n))
        ["-n", n] -> migrate(repo, :down, step: String.to_integer(n))
        ["--to", to] -> migrate(repo, :down, to: to)
        ["--all"] -> migrate(repo, :down, all: true)
        [] -> migrate(repo, :down, step: 1)
      end
    end)
  end

  defp migrate(repo, direction, opts) do
    migrations_path = priv_path_for(repo, "migrations")
    Ecto.Migrator.run(repo, migrations_path, direction, opts)
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config(), :otp_app)
    priv_dir = Application.app_dir(app, "priv")

    Path.join([priv_dir, "repo", filename])
  end
end
