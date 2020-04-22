defmodule Pontinho.AbandonGame do
  @moduledoc """
  Abandon game
  """

  import Ecto.Changeset

  alias Pontinho.{Player, Repo}

  @minimum_broke_times 4

  @spec run(%Player{}) :: {:ok, %Player{}} | {:error, %Ecto.Changeset{}}
  def run(%Player{} = player) do
    player
    |> change()
    |> put_change(:broke_times, calculate_broke_times(player))
    |> put_change(:playing, false)
    |> Repo.update()
  end

  defp calculate_broke_times(%Player{broke_times: broke_times})
       when broke_times < @minimum_broke_times,
       do: @minimum_broke_times

  defp calculate_broke_times(%Player{broke_times: broke_times}), do: broke_times
end
