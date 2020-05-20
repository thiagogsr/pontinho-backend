defmodule Pontinho.Event.AskBeat do
  @moduledoc """
  Ask beat event
  """

  @behaviour Pontinho.Event

  def validate(_match, match_player, _match_collection, _cards, previous_event) do
    if match_player.false_beat || is_nil(previous_event) || previous_event.type == "ASK_BEAT" do
      ["invalid operation"]
    else
      []
    end
  end

  def run(_match, _match_player, _match_collection, _cards, _previous_event) do
  end
end
