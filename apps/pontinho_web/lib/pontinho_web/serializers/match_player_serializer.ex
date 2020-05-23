defmodule PontinhoWeb.MatchPlayerSerializer do
  @moduledoc """
  Match player serialization
  """

  @spec serialize(map) :: map
  def serialize(%{match_player: match_player, previous_event: previous_event})
      when is_nil(previous_event) do
    %{
      match_player_id: match_player.id,
      match_player_hand: match_player.hand,
      false_beat: match_player.false_beat,
      asked_beat: false,
      taked_card: nil
    }
  end

  def serialize(%{match_player: match_player, previous_event: previous_event}) do
    %{
      match_player_id: match_player.id,
      match_player_hand: match_player.hand,
      false_beat: match_player.false_beat,
      asked_beat: previous_event.type == "ASK_BEAT",
      bought_first_card: previous_event.type == "BUY_FIRST_CARD",
      taked_card: previous_event.taked_card
    }
  end
end
