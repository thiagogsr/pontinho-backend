defmodule Pontinho.UpdateMatchPlayer do
  @moduledoc """
  Match player update
  """

  import Ecto.Changeset

  alias Pontinho.{MatchPlayer, Repo}

  @spec run(%MatchPlayer{}, map) :: {:ok, %MatchPlayer{}}
  def run(match_player, attributes) do
    match_player
    |> cast(attributes, [:hand, :false_beat])
    |> Repo.update()
  end
end
