defmodule Pontinho.Event.AskBeat do
  @moduledoc """
  Ask beat event
  """

  @behaviour Pontinho.Event

  alias Pontinho.UpdateMatchPlayer

  def validate(_match, match_player, _match_collection, _cards, _previous_event) do
    if match_player.asked_beat || match_player.false_beat do
      ["invalid operation"]
    else
      []
    end
  end

  def run(_match, match_player, _match_collection, _cards, _previous_event) do
    UpdateMatchPlayer.run(match_player, %{asked_beat: true})
  end
end
