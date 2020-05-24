defmodule Pontinho.Event.Beat do
  @moduledoc """
  Beat event
  """

  @behaviour Pontinho.Event

  alias Pontinho.FinishMatch

  def validate(_match, match_player, _match_collection, _cards, previous_event) do
    if Enum.empty?(match_player.hand) && previous_event.match_player_id == match_player.id do
      []
    else
      ["invalid operation"]
    end
  end

  def run(match, match_player, _match_collection, _cards, _previous_event) do
    FinishMatch.run(match, match_player)
  end
end
