defmodule Pontinho.CreateMatchCollectionTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.{CreateMatchCollection, MatchCollection}

  setup do
    match = insert(:match)
    match_player = insert(:match_player)

    %{match: match, match_player: match_player}
  end

  test "inserts a match collection", %{match: match, match_player: match_player} do
    cards = [
      %{value: "2", suit: "diamonds"},
      %{value: "3", suit: "diamonds"},
      %{value: "4", suit: "diamonds"}
    ]

    type = "sequence"

    assert {:ok, %MatchCollection{} = match_collection} =
             CreateMatchCollection.run(match, match_player, type, cards)

    assert match_collection.dropped_by == match_player
  end

  test "returns error when there are less than 3 cards", %{
    match: match,
    match_player: match_player
  } do
    cards = [
      %{value: "2", suit: "diamonds"},
      %{value: "3", suit: "diamonds"}
    ]

    type = "sequence"

    assert {:error, %Ecto.Changeset{} = changeset} =
             CreateMatchCollection.run(match, match_player, type, cards)

    assert %{cards: ["should have at least 3 item(s)"]} = errors_on(changeset)
  end
end
