defmodule PontinhoWeb.MatchSerializer do
  @moduledoc """
  Serialize a match to broadcast via WebSocket
  """

  @spec serialize(map, map) :: map
  def serialize(match, match_player) do
    %{
      match_id: match.id,
      match_player_id: match_player.id,
      match_player_hand: match_player.hand,
      pre_joker: match.pre_joker,
      no_stock: match.stock |> Enum.empty?(),
      head_discard_pile: match.discard_pile |> List.first(),
      match_collections: Enum.map(match.match_collections, &match_collection_json/1),
      match_players: Enum.map(match.match_players, &match_player_json/1)
    }
  end

  defp match_collection_json(match_collection) do
    %{
      id: match_collection.id,
      cards: match_collection.cards,
      type: match_collection.type
    }
  end

  defp match_player_json(match_player) do
    %{
      id: match_player.id,
      name: match_player.player.name,
      points: match_player.player.points,
      broke_times: match_player.player.broke_times,
      cards: match_player.hand |> length()
    }
  end
end
