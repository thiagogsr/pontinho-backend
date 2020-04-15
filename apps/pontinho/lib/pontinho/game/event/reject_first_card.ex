defmodule Pontinho.Event.RejectFirstCard do
  @moduledoc """
  Reject first card event
  """

  @behaviour Pontinho.Event

  alias Pontinho.{UpdateMatch, UpdateMatchPlayer}

  def validate(_match, match_player, _match_collection, _cards, previous_event) do
    if previous_event.type == "BUY_FIRST_CARD" &&
         previous_event.match_player_id == match_player.id &&
         is_map(match_player.first_card) do
      []
    else
      ["invalid operation"]
    end
  end

  def run(match, match_player, _match_collection, _cards) do
    %{first_card: first_card} = match_player
    UpdateMatch.run(match, %{discard_pile: [first_card | match.discard_pile]})
    UpdateMatchPlayer.run(match_player, %{first_card: nil})
  end
end
