defmodule Pontinho.JoinGame do
  @moduledoc """
  Joining in a game
  """

  alias Pontinho.{Game, Player, Repo}

  import Ecto.{Changeset, Query}

  @default_points 99

  @spec run(%Game{}, String.t()) :: {:ok, %Player{}} | {:error, %Ecto.Changeset{}}
  def run(game, player_name) do
    Repo.transaction(fn repo ->
      sequence = fetch_sequence(repo, game)

      case insert_player(repo, game, player_name, sequence) do
        {:ok, player} -> player
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  defp fetch_sequence(repo, %{id: game_id} = _game) do
    query = from(p in Player, where: p.game_id == ^game_id, select: max(p.sequence), limit: 1)

    case repo.one(query) do
      nil -> 0
      sequence -> sequence + 1
    end
  end

  defp insert_player(repo, game, player_name, sequence) do
    %Player{}
    |> change()
    |> put_change(:name, player_name)
    |> validate_required([:name])
    |> put_change(:sequence, sequence)
    |> put_change(:broke_times, 0)
    |> put_change(:points, @default_points)
    |> put_change(:playing, true)
    |> put_assoc(:game, game)
    |> repo.insert()
  end
end
