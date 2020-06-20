defmodule Pontinho.Event.FalseBeat do
  @moduledoc """
  False beat event
  """

  @behaviour Pontinho.Event

  alias Pontinho.UpdateMatchPlayer

  def validate(_match, match_player, _match_collection, _cards, _previous_event) do
    if match_player.asked_beat do
      []
    else
      ["invalid operation"]
    end
  end

  def run(_match, match_player, _match_collection, _cards, _previous_event) do
    UpdateMatchPlayer.run(match_player, %{asked_beat: false, false_beat: true})
  end
end
