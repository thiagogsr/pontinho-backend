defmodule PontinhoWeb.MatchPlayerSerializer do
  @moduledoc """
  Match player serialization
  """

  @spec serialize(map) :: map
  def serialize(match_player) do
    %{
      match_player_id: match_player.id,
      match_player_hand: match_player.hand
    }
  end
end
