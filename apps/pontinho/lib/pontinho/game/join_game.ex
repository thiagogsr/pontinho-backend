defmodule Pontinho.JoinGame do
  @moduledoc """
  Joining in a game
  """

  alias Pontinho.{Game, Match, Player, Repo}

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @default_points 99

  @spec run(%Game{}, String.t()) :: {:ok, %Player{}} | {:error, %Ecto.Changeset{}}
  def run(game, player_name, opts \\ []) do
    Repo.transaction(fn repo ->
      if game_already_started?(game) do
        Repo.rollback("game already started")
      else
        host = Keyword.get(opts, :host, false)

        case insert_player(repo, game, player_name, host) do
          {:ok, player} -> player
          {:error, changeset} -> Repo.rollback(changeset)
        end
      end
    end)
  end

  defp game_already_started?(%{id: game_id}) do
    from(m in Match, where: m.game_id == ^game_id)
    |> Repo.aggregate(:count, :id)
    |> Kernel.>(0)
  end

  defp insert_player(repo, game, player_name, host) do
    sequence = next_sequence(repo, game)

    %Player{}
    |> change()
    |> put_change(:name, player_name)
    |> validate_required([:name])
    |> unique_constraint([:name, :game_id])
    |> put_change(:sequence, sequence)
    |> put_change(:broke_times, 0)
    |> put_change(:points, @default_points)
    |> put_change(:playing, true)
    |> put_change(:host, host)
    |> put_assoc(:game, game)
    |> repo.insert()
  end

  defp next_sequence(repo, %{id: game_id} = _game) do
    query = from(p in Player, where: p.game_id == ^game_id, select: max(p.sequence), limit: 1)

    case repo.one(query) do
      nil -> 0
      sequence -> sequence + 1
    end
  end
end
