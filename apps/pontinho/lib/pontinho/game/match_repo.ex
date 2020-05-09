defmodule Pontinho.MatchRepo do
  @moduledoc """
  Match repository
  """

  import Ecto.Query, only: [from: 2]

  alias Pontinho.{Match, MatchCollection, MatchPlayer, Repo}

  @spec get_match!(String.t()) :: %Match{}
  def get_match!(match_id) do
    Match
    |> Repo.get!(match_id)
    |> Repo.preload(
      match_collections: match_collections_query(),
      match_players: match_players_query()
    )
  end

  defp match_collections_query do
    from(mc in MatchCollection, order_by: mc.inserted_at)
  end

  defp match_players_query do
    from(
      mp in MatchPlayer,
      join: p in assoc(mp, :player),
      order_by: p.sequence,
      preload: [player: p]
    )
  end
end
