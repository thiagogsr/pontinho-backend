defmodule Pontinho.MatchRepo do
  @moduledoc """
  Match repository
  """

  import Ecto.Query, only: [from: 2]

  alias Pontinho.{MatchPlayer, Repo}

  @spec find_match_player(String.t(), String.t()) :: %MatchPlayer{} | nil
  def find_match_player(match_id, player_id) do
    from(
      mp in MatchPlayer,
      where: mp.match_id == ^match_id,
      where: mp.player_id == ^player_id,
      limit: 1
    )
    |> Repo.one()
  end
end
