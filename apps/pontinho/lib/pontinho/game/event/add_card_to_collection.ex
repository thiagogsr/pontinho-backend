defmodule Pontinho.Event.AddCardToCollection do
  @moduledoc """
  Adding a card to a collection
  """

  @behaviour Pontinho.Event

  alias Pontinho.{Collection, Deck, UpdateMatchCollection, UpdateMatchPlayer}

  def validate(match, match_player, _match_collection, cards, previous_event) do
    valid_operation =
      previous_event.match_player_id == match_player.id &&
        cond do
          previous_event.type == "REPLACE_JOKER" && match.joker in cards -> true
          previous_event.type in ["BUY", "ASK_BEAT"] -> true
          true -> false
        end

    if valid_operation do
      case Collection.validate(cards, match.joker, false) do
        {:ok, _} -> []
        {:error, error} -> [error]
      end
    else
      ["invalid operation"]
    end
  end

  def run(_match, match_player, match_collection, cards) do
    new_match_collection_cards = Deck.remove_cards(cards, match_collection.cards)
    match_player_cards = Deck.remove_cards(match_player.hand, new_match_collection_cards)

    UpdateMatchPlayer.run(match_player, %{hand: match_player_cards})
    UpdateMatchCollection.run(match_collection, %{cards: cards})
  end
end
