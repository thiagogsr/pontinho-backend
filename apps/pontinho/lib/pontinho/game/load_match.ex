defmodule Pontinho.LoadMatch do
  @moduledoc """
  Load match current state
  """

  import Ecto.Query, only: [from: 2]

  alias Pontinho.{Match, MatchCollection, MatchEvent, MatchPlayer, Repo}

  @spec run(String.t()) :: %{match: %Match{}, round_match_player: %MatchPlayer{}}
  def run(match_id) do
    match = load_match!(match_id)
    last_event = get_last_match_event(match_id)
    round_match_player = get_next_match_player(match, last_event)

    %{match: match, round_match_player: round_match_player}
  end

  defp load_match!(match_id) do
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

  defp get_last_match_event(match_id) do
    query =
      from(
        me in MatchEvent,
        where: me.match_id == ^match_id,
        order_by: [desc: me.inserted_at],
        limit: 1,
        preload: [:match_player]
      )

    Repo.one(query)
  end

  defp get_next_match_player(match, last_event) when is_nil(last_event) do
    get_player_after(match.match_players, match.croupier_id)
  end

  defp get_next_match_player(match, %{match_player: %{player_id: player_id}} = _last_event) do
    get_player_after(match.match_players, player_id)
  end

  defp get_player_after(match_players, player_id) do
    {_players_ids_before, [_player_id | players_ids_after]} =
      match_players
      |> Enum.map(& &1.player_id)
      |> Enum.split_while(&(&1 != player_id))

    next_player_id = List.first(players_ids_after)
    Enum.find(match_players, &(&1.player_id == next_player_id))
  end
end
