defmodule PontinhoWeb.MatchPlayerSerializer do
  @moduledoc """
  Match player serialization
  """

  @spec serialize(map) :: map
  def serialize(%{match_player: match_player, asked_beat: asked_beat, taked_card: taked_card}) do
    %{
      match_player_id: match_player.id,
      match_player_hand: match_player.hand,
      false_beat: match_player.false_beat,
      asked_beat: asked_beat,
      taked_card: taked_card
    }
  end
end
