defmodule Pontinho.Event.FalseBeat do
  @moduledoc """
  False beat event
  """

  @behaviour Pontinho.Event

  alias Pontinho.UpdateMatchPlayer

  def validate(_match, match_player, _match_collection, _cards, previous_event) do
    if previous_event.type == "ASK_BEAT" && previous_event.match_player_id == match_player.id do
      []
    else
      ["invalid operation"]
    end
  end

  def run(_match, match_player, _match_collection, _cards, _previous_event) do
    UpdateMatchPlayer.run(match_player, %{false_beat: true})
  end
end
