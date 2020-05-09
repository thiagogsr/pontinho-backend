defmodule Pontinho.Event.AskBeat do
  @moduledoc """
  Ask beat event
  """

  @behaviour Pontinho.Event

  def validate(_match, match_player, _match_collection, _cards, _previous_event) do
    if match_player.false_beat do
      ["invalid operation"]
    else
      []
    end
  end

  def run(_match, _match_player, _match_collection, _cards, _previous_event) do
  end
end
