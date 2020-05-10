defmodule PontinhoWeb.MatchSerializer do
  @moduledoc """
  Match serialization
  """

  @spec serialize(map) :: map
  def serialize(%{match: match, round_match_player: round_match_player}) do
    %{
      match_id: match.id,
      pre_joker: match.pre_joker,
      head_stock_deck: head_stock_deck(match.stock),
      head_discard_pile: match.discard_pile |> List.first(),
      match_collections: Enum.map(match.match_collections, &match_collection_json/1),
      match_players: Enum.map(match.match_players, &match_player_json/1),
      round_match_player_id: round_match_player.id
    }
  end

  defp head_stock_deck(stock) when stock == [], do: nil
  defp head_stock_deck([head | _tail] = _stock), do: head["deck"]

  defp match_collection_json(match_collection) do
    %{
      id: match_collection.id,
      type: match_collection.type,
      cards: match_collection.cards
    }
  end

  defp match_player_json(match_player) do
    %{
      match_player_id: match_player.id,
      player_name: match_player.player.name,
      game_points: match_player.player.points,
      broke_times: match_player.player.broke_times,
      number_of_cards: match_player.hand |> length(),
      false_beat: match_player.false_beat
    }
  end
end
