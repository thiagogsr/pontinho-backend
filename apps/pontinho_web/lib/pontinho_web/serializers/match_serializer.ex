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
      cards: group_cards(match_collection.cards)
    }
  end

  defp group_cards(cards) do
    cards
    |> Enum.group_by(&(&1["value"] && &1["suit"]))
    |> Enum.map(fn {_agg, grouped_cards} ->
      case grouped_cards do
        [card] -> card
        cards -> cards
      end
    end)
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
