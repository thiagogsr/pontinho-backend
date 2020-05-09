defmodule Pontinho.Event.TakeDiscardPile do
  @moduledoc """
  Taking the top discard pile card
  """

  @behaviour Pontinho.Event

  alias Pontinho.UpdateMatch

  def validate(match, match_player, _match_collection, _cards, previous_event) do
    cond do
      !Enum.empty?(match.discard_pile) && previous_event.match_player_id != match_player.id &&
          previous_event.type == "DISCARD" ->
        []

      !Enum.empty?(match.discard_pile) && previous_event.match_player_id == match_player.id &&
          previous_event.type == "ASK_BEAT" ->
        []

      true ->
        ["invalid operation"]
    end
  end

  def run(match, _match_player, _match_collection, _cards, _previous_event) do
    [taked_card | discard_pile] = match.discard_pile
    UpdateMatch.run(match, %{discard_pile: discard_pile})

    {:cast, :taked_card, taked_card}
  end
end
