defmodule Pontinho.UpdateMatchCollectionTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.{MatchCollection, UpdateMatchCollection}

  test "updates the match collection cards" do
    current_cards = [
      %{"value" => "2", "suit" => "clubs", "deck" => 1, "order" => 0},
      %{"value" => "2", "suit" => "hearts", "deck" => 1, "order" => 1},
      %{"value" => "2", "suit" => "spades", "deck" => 1, "order" => 2}
    ]

    new_cards = [
      %{"value" => "2", "suit" => "clubs", "deck" => 1},
      %{"value" => "2", "suit" => "hearts", "deck" => 1},
      %{"value" => "2", "suit" => "hearts", "deck" => 2},
      %{"value" => "2", "suit" => "spades", "deck" => 1}
    ]

    match_collection = insert(:match_collection, cards: current_cards)

    assert {:ok, %MatchCollection{} = updated_match_collection} =
             UpdateMatchCollection.run(match_collection, %{cards: new_cards})

    assert %{
             cards: [
               %{"value" => "2", "suit" => "clubs", "deck" => 1, "order" => 0},
               %{"value" => "2", "suit" => "hearts", "deck" => 1, "order" => 1},
               %{"value" => "2", "suit" => "hearts", "deck" => 2, "order" => 2},
               %{"value" => "2", "suit" => "spades", "deck" => 1, "order" => 3}
             ]
           } = updated_match_collection
  end
end
