defmodule Pontinho.Event.DropCollection do
  @moduledoc """
  Drop collection event
  """

  @behaviour Pontinho.Event

  alias Pontinho.{Collection, CreateMatchCollection, Deck, UpdateMatchPlayer}

  def validate(match, match_player, _match_collection, cards, previous_event) do
    if validate_match_player(match_player, previous_event) &&
         validate_cards(match_player, cards, previous_event.taked_card) &&
         validate_operation(match, cards, previous_event) do
      case Collection.validate(cards, match.joker, previous_event.type == "ASK_BEAT") do
        {:ok, _} -> []
        {:error, error} -> [error]
      end
    else
      ["invalid operation"]
    end
  end

  defp validate_match_player(match_player, previous_event) do
    previous_event.match_player_id == match_player.id
  end

  defp validate_cards(match_player, cards, taked_card) do
    match_player_cards = Enum.reject([taked_card | match_player.hand], &is_nil/1)
    cards -- match_player_cards == []
  end

  defp validate_operation(match, cards, previous_event) do
    cond do
      previous_event.type == "REPLACE_JOKER" && match.joker in cards ->
        true

      previous_event.type == "TAKE_DISCARD_PILE" && previous_event.taked_card in cards ->
        true

      previous_event.type in [
        "BUY",
        "ASK_BEAT",
        "DROP_COLLECTION",
        "ADD_CARD_TO_COLLECTION",
        "ACCEPT_FIRST_CARD"
      ] ->
        true

      true ->
        false
    end
  end

  def run(match, match_player, _match_collection, cards, previous_event) do
    {:ok, %{type: type}} =
      Collection.validate(cards, match.joker, previous_event.type == "ASK_BEAT")

    match_player_cards = Deck.remove_cards(match_player.hand, cards)

    UpdateMatchPlayer.run(match_player, %{hand: match_player_cards})
    CreateMatchCollection.run(match, match_player, type, cards)
  end
end
