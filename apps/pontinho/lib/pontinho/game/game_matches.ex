defmodule Pontinho.GameMatches do
  @moduledoc """
  Listing the game matches
  """

  import Ecto.Query, only: [from: 2]

  alias Pontinho.{Game, Match, MatchPlayer, Repo}

  @spec list(%Game{}) :: list(%Match{})
  def list(game) do
    game
    |> Repo.preload(matches: matches_query())
    |> Map.get(:matches)
  end

  defp matches_query do
    from(
      m in Match,
      order_by: m.inserted_at,
      preload: [:croupier, match_players: ^match_players_query()]
    )
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
