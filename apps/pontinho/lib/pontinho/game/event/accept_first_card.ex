defmodule Pontinho.Event.AcceptFirstCard do
  @moduledoc """
  Accept first card event
  """

  @behaviour Pontinho.Event

  alias Pontinho.UpdateMatchPlayer

  def validate(_match, match_player, _match_collection, _cards, previous_event) do
    if previous_event.type == "BUY_FIRST_CARD" &&
         previous_event.match_player_id == match_player.id &&
         is_map(match_player.first_card) do
      []
    else
      ["invalid operation"]
    end
  end

  def run(_match, match_player, _match_collection, _cards) do
    UpdateMatchPlayer.run(match_player, %{
      first_card: nil,
      hand: [match_player.first_card | match_player.hand]
    })
  end
end
