defmodule Pontinho.AbandonGame do
  @moduledoc """
  Abandon game
  """

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Pontinho.{Player, Repo}

  @minimum_broke_times 4

  @spec run(%Player{}) :: {:ok, %Player{}} | {:error, %Ecto.Changeset{}}
  def run(%Player{} = player) do
    Repo.transaction(fn ->
      with {:ok, updated_player} <- update_player(player),
           {:ok, _new_host} <- choose_new_host(player) do
        updated_player
      else
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  defp update_player(player) do
    player
    |> change()
    |> put_change(:broke_times, calculate_broke_times(player))
    |> put_change(:playing, false)
    |> put_change(:host, false)
    |> Repo.update()
  end

  defp choose_new_host(%Player{host: true, id: player_id, game_id: game_id}) do
    query =
      from(
        p in Player,
        where: p.game_id == ^game_id,
        where: p.id != ^player_id,
        where: p.playing,
        order_by: p.inserted_at,
        limit: 1
      )

    query
    |> Repo.one()
    |> change(%{host: true})
    |> Repo.update()
  end

  defp choose_new_host(%Player{host: false} = player) do
    {:ok, player}
  end

  defp calculate_broke_times(%Player{broke_times: broke_times})
       when broke_times < @minimum_broke_times,
       do: @minimum_broke_times

  defp calculate_broke_times(%Player{broke_times: broke_times}), do: broke_times
end
