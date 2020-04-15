defmodule Pontinho.UpdateMatchPlayer do
  @moduledoc """
  Match player update
  """

  import Ecto.Changeset

  alias Pontinho.{MatchPlayer, Repo}

  @spec run(%MatchPlayer{}, map) :: {:ok, %MatchPlayer{}}
  def run(match_player, attributes) do
    match_player
    |> cast(attributes, [:hand, :false_beat, :ask_beat, :first_card, :discard_pile_card])
    |> Repo.update()
  end
end
