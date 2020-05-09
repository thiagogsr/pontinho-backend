defmodule Pontinho.Event.RejectFirstCard do
  @moduledoc """
  Reject first card event
  """

  @behaviour Pontinho.Event

  alias Pontinho.UpdateMatch

  def validate(_match, match_player, _match_collection, _cards, previous_event) do
    if previous_event.type == "BUY_FIRST_CARD" &&
         previous_event.match_player_id == match_player.id do
      []
    else
      ["invalid operation"]
    end
  end

  def run(match, _match_player, _match_collection, _cards, previous_event) do
    %{taked_card: taked_card} = previous_event
    UpdateMatch.run(match, %{discard_pile: [taked_card | match.discard_pile]})
  end
end
