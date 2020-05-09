defmodule Pontinho.CreateMatchEventTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.{CreateMatchEvent, Match, MatchCollection, MatchEvent, MatchPlayer, Repo}

  describe "ACCEPT_FIRST_CARD" do
    test "returns ok when event is valid" do
      match = insert(:match)
      match_player = insert(:match_player, hand: [])

      insert(:match_event,
        match: match,
        match_player: match_player,
        type: "BUY_FIRST_CARD",
        taked_card: %{"value" => "2", "suit" => "diamonds", "deck" => 1}
      )

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 nil,
                 "ACCEPT_FIRST_CARD",
                 []
               )

      assert match_event.type == "ACCEPT_FIRST_CARD"

      assert %MatchPlayer{
               hand: [%{"value" => "2", "suit" => "diamonds", "deck" => 1}]
             } = Repo.get(MatchPlayer, match_player.id)
    end

    test "returns error when previous event was not BUY_FIRST_CARD" do
      match = insert(:match)
      match_player = insert(:match_player, hand: [])
      insert(:match_event, match: match, match_player: match_player, type: "BUY")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 nil,
                 "ACCEPT_FIRST_CARD",
                 []
               )

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when the previous event was made by other match player" do
      match = insert(:match)
      match_player = insert(:match_player, hand: [])

      insert(:match_event,
        match: match,
        type: "BUY_FIRST_CARD",
        taked_card: %{"value" => "2", "suit" => "diamonds", "deck" => 1}
      )

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 nil,
                 "ACCEPT_FIRST_CARD",
                 []
               )

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "ADD_CARD_TO_COLLECTION" do
    test "returns ok when previous event was REPLACE_JOKER" do
      match = insert(:match, joker: %{"value" => "2", "suit" => "diamonds", "deck" => 1})

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "diamonds", "deck" => 1},
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "K", "suit" => "diamonds", "deck" => 1}
          ]
        )

      match_collection =
        insert(:match_collection,
          match: match,
          cards: [
            %{"value" => "9", "suit" => "hearts", "deck" => 1},
            %{"value" => "10", "suit" => "hearts", "deck" => 1},
            %{"value" => "J", "suit" => "hearts", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "REPLACE_JOKER")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 match_collection,
                 "ADD_CARD_TO_COLLECTION",
                 [
                   %{"value" => "9", "suit" => "hearts", "deck" => 1},
                   %{"value" => "10", "suit" => "hearts", "deck" => 1},
                   %{"value" => "J", "suit" => "hearts", "deck" => 1},
                   %{"value" => "2", "suit" => "diamonds", "deck" => 1},
                   %{"value" => "K", "suit" => "hearts", "deck" => 1}
                 ]
               )

      assert match_event.type == "ADD_CARD_TO_COLLECTION"

      assert %MatchPlayer{hand: [%{"value" => "K", "suit" => "diamonds", "deck" => 1}]} =
               Repo.get(MatchPlayer, match_player.id)

      assert %MatchCollection{
               cards: [
                 %{"value" => "9", "suit" => "hearts", "deck" => 1},
                 %{"value" => "10", "suit" => "hearts", "deck" => 1},
                 %{"value" => "J", "suit" => "hearts", "deck" => 1},
                 %{"value" => "2", "suit" => "diamonds", "deck" => 1},
                 %{"value" => "K", "suit" => "hearts", "deck" => 1}
               ]
             } = Repo.get(MatchCollection, match_collection.id)
    end

    test "returns ok when previous event was BUY" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "diamonds", "deck" => 1},
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "K", "suit" => "diamonds", "deck" => 1}
          ]
        )

      match_collection =
        insert(:match_collection,
          match: match,
          type: "trio",
          cards: [
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "K", "suit" => "suits", "deck" => 1},
            %{"value" => "K", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "BUY")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 match_collection,
                 "ADD_CARD_TO_COLLECTION",
                 [
                   %{"value" => "K", "suit" => "hearts", "deck" => 1},
                   %{"value" => "K", "suit" => "suits", "deck" => 1},
                   %{"value" => "K", "suit" => "clubs", "deck" => 1},
                   %{"value" => "K", "suit" => "hearts", "deck" => 1}
                 ]
               )

      assert match_event.type == "ADD_CARD_TO_COLLECTION"

      assert %MatchPlayer{
               hand: [
                 %{"value" => "2", "suit" => "diamonds", "deck" => 1},
                 %{"value" => "K", "suit" => "diamonds", "deck" => 1}
               ]
             } = Repo.get(MatchPlayer, match_player.id)

      assert %MatchCollection{
               cards: [
                 %{"value" => "K", "suit" => "hearts", "deck" => 1},
                 %{"value" => "K", "suit" => "suits", "deck" => 1},
                 %{"value" => "K", "suit" => "clubs", "deck" => 1},
                 %{"value" => "K", "suit" => "hearts", "deck" => 1}
               ]
             } = Repo.get(MatchCollection, match_collection.id)
    end

    test "returns ok when previous event was ASK_BEAT" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "diamonds", "deck" => 1},
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "K", "suit" => "diamonds", "deck" => 1}
          ]
        )

      match_collection =
        insert(:match_collection,
          match: match,
          type: "trio",
          cards: [
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "K", "suit" => "suits", "deck" => 1},
            %{"value" => "K", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "ASK_BEAT")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 match_collection,
                 "ADD_CARD_TO_COLLECTION",
                 [
                   %{"value" => "K", "suit" => "hearts", "deck" => 1},
                   %{"value" => "K", "suit" => "suits", "deck" => 1},
                   %{"value" => "K", "suit" => "clubs", "deck" => 1},
                   %{"value" => "K", "suit" => "hearts", "deck" => 1}
                 ]
               )

      assert match_event.type == "ADD_CARD_TO_COLLECTION"

      assert %MatchPlayer{
               hand: [
                 %{"value" => "2", "suit" => "diamonds", "deck" => 1},
                 %{"value" => "K", "suit" => "diamonds", "deck" => 1}
               ]
             } = Repo.get(MatchPlayer, match_player.id)

      assert %MatchCollection{
               cards: [
                 %{"value" => "K", "suit" => "hearts", "deck" => 1},
                 %{"value" => "K", "suit" => "suits", "deck" => 1},
                 %{"value" => "K", "suit" => "clubs", "deck" => 1},
                 %{"value" => "K", "suit" => "hearts", "deck" => 1}
               ]
             } = Repo.get(MatchCollection, match_collection.id)
    end

    test "returns error when the previous event is REPLACE_JOKER but joker is not present in this collection" do
      match = insert(:match, joker: %{"value" => "2", "suit" => "diamonds", "deck" => 1})

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "diamonds", "deck" => 1},
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "Q", "suit" => "hearts", "deck" => 1}
          ]
        )

      match_collection =
        insert(:match_collection,
          match: match,
          cards: [
            %{"value" => "9", "suit" => "hearts", "deck" => 1},
            %{"value" => "10", "suit" => "hearts", "deck" => 1},
            %{"value" => "J", "suit" => "hearts", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "REPLACE_JOKER")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 match_collection,
                 "ADD_CARD_TO_COLLECTION",
                 [
                   %{"value" => "9", "suit" => "hearts", "deck" => 1},
                   %{"value" => "10", "suit" => "hearts", "deck" => 1},
                   %{"value" => "J", "suit" => "hearts", "deck" => 1},
                   %{"value" => "Q", "suit" => "hearts", "deck" => 1},
                   %{"value" => "K", "suit" => "hearts", "deck" => 1}
                 ]
               )

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when the collection is invalid" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "diamonds", "deck" => 2},
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "K", "suit" => "diamonds", "deck" => 1}
          ]
        )

      match_collection =
        insert(:match_collection,
          match: match,
          type: "trio",
          cards: [
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "K", "suit" => "suits", "deck" => 1},
            %{"value" => "K", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "ASK_BEAT")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 match_collection,
                 "ADD_CARD_TO_COLLECTION",
                 [
                   %{"value" => "K", "suit" => "hearts", "deck" => 1},
                   %{"value" => "K", "suit" => "suits", "deck" => 1},
                   %{"value" => "K", "suit" => "clubs", "deck" => 1},
                   %{"value" => "2", "suit" => "diamonds", "deck" => 2}
                 ]
               )

      assert %{cards: ["invalid trio"]} = errors_on(changeset)
    end

    test "returns error when the previous event was made by other match player" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "diamonds", "deck" => 1},
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "K", "suit" => "diamonds", "deck" => 1}
          ]
        )

      match_collection =
        insert(:match_collection,
          match: match,
          type: "trio",
          cards: [
            %{"value" => "K", "suit" => "hearts", "deck" => 1},
            %{"value" => "K", "suit" => "suits", "deck" => 1},
            %{"value" => "K", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, type: "ASK_BEAT")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 match_collection,
                 "ADD_CARD_TO_COLLECTION",
                 [
                   %{"value" => "K", "suit" => "hearts", "deck" => 1},
                   %{"value" => "K", "suit" => "suits", "deck" => 1},
                   %{"value" => "K", "suit" => "clubs", "deck" => 1},
                   %{"value" => "K", "suit" => "diamonds", "deck" => 1}
                 ]
               )

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "ASK_BEAT" do
    test "returns ok when match player did not false beat yet" do
      match = insert(:match)
      match_player = insert(:match_player, false_beat: false)

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "ASK_BEAT", [])

      assert match_event.type == "ASK_BEAT"
    end

    test "returns error when match player false bet before" do
      match = insert(:match)
      match_player = insert(:match_player, false_beat: true)

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "ASK_BEAT", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "BEAT" do
    test "returns ok when match player hand is empty and the previous event was made by the same match player" do
      match = insert(:match)
      match_player = insert(:match_player, hand: [])
      insert(:match_event, match: match, match_player: match_player)

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "BEAT", [])

      assert match_event.type == "BEAT"
    end

    test "returns error when match player hand is empty but the previous event was made by other match player" do
      match = insert(:match)
      match_player = insert(:match_player, hand: [])
      insert(:match_event, match: match)

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "BEAT", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when match player hand is not empty" do
      match = insert(:match)

      match_player =
        insert(:match_player, hand: [%{"value" => "A", "suit" => "clubs", "deck" => 1}])

      insert(:match_event, match: match, match_player: match_player)

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "BEAT", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "BUY_FIRST_CARD" do
    test "returns ok when previous event is nil" do
      match = insert(:match)
      match_player = insert(:match_player)

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "BUY_FIRST_CARD", [])

      assert match_event.type == "BUY_FIRST_CARD"
      assert match_event.taked_card == hd(match.stock)
    end

    test "returns error when previous event is not nil" do
      match = insert(:match)
      match_player = insert(:match_player)
      insert(:match_event, match: match)

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "BUY_FIRST_CARD", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "BUY" do
    test "returns ok when previous event was DISCARD" do
      match = insert(:match)
      match_player = insert(:match_player)
      insert(:match_event, match: match, type: "DISCARD")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "BUY", [])

      assert match_event.type == "BUY"
      assert Repo.get(Match, match.id).stock |> length() == length(match.stock) - 1

      %MatchPlayer{hand: match_player_hand} = Repo.get(MatchPlayer, match_player.id)
      assert length(match_player_hand) == length(match_player.hand) + 1
    end

    test "returns ok when previous event was REJECT_FIRST_CARD for the same match player" do
      match = insert(:match)
      match_player = insert(:match_player)
      insert(:match_event, match: match, match_player: match_player, type: "REJECT_FIRST_CARD")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "BUY", [])

      assert match_event.type == "BUY"
      assert Repo.get(Match, match.id).stock |> length() == length(match.stock) - 1

      %MatchPlayer{hand: match_player_hand} = Repo.get(MatchPlayer, match_player.id)
      assert hd(match.stock) == hd(match_player_hand)
      assert length(match_player_hand) == length(match_player.hand) + 1
    end

    test "moves discard pile to stock when there is no stock after buy" do
      stock_card = %{"value" => "7", "suit" => "clubs", "deck" => 1}

      discard_pile = [
        %{"value" => "3", "suit" => "diamonds", "deck" => 1},
        %{"value" => "A", "suit" => "clubs", "deck" => 1},
        %{"value" => "K", "suit" => "spades", "deck" => 1}
      ]

      match = insert(:match, stock: [stock_card], discard_pile: discard_pile)

      match_player = insert(:match_player)
      insert(:match_event, match: match, type: "DISCARD")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "BUY", [])

      assert match_event.type == "BUY"

      assert %Match{stock: new_stock, discard_pile: new_discard_pile} = Repo.get(Match, match.id)
      assert new_stock -- discard_pile == []
      assert new_discard_pile == []

      %MatchPlayer{hand: match_player_hand} = Repo.get(MatchPlayer, match_player.id)
      assert hd(match_player_hand) == stock_card
      assert length(match_player_hand) == length(match_player.hand) + 1
    end

    test "returns error when previous event was DISCARD for the same match player" do
      match = insert(:match)
      match_player = insert(:match_player)
      insert(:match_event, match: match, match_player: match_player, type: "DISCARD")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "BUY", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when previous event was REJECT_FIRST_CARD for other match player" do
      match = insert(:match)
      match_player = insert(:match_player)
      insert(:match_event, match: match, type: "REJECT_FIRST_CARD")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "BUY", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when previous event was any type except DISCARD and REJECT_FIRST_CARD" do
      match = insert(:match)
      match_player = insert(:match_player)
      insert(:match_event, match: match, type: "BUY")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "BUY", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "DISCARD" do
    test "returns ok when previous event is DROP_COLLECTION, BUY or ACCEPT_FIRST_CARD" do
      match = insert(:match, joker: %{"value" => "10", "suit" => "clubs", "deck" => 1})

      match_player =
        insert(:match_player, hand: [%{"value" => "2", "suit" => "clubs", "deck" => 1}])

      random_type = ["DROP_COLLECTION", "BUY", "ACCEPT_FIRST_CARD"] |> Enum.random()
      insert(:match_event, match: match, match_player: match_player, type: random_type)

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "DISCARD", [
                 %{"value" => "2", "suit" => "clubs", "deck" => 1}
               ])

      assert match_event.type == "DISCARD"

      %Match{discard_pile: match_discard_pile} = Repo.get(Match, match.id)
      assert length(match_discard_pile) == length(match.discard_pile) + 1
      assert %{"value" => "2", "suit" => "clubs", "deck" => 1} = hd(match_discard_pile)

      %MatchPlayer{hand: match_player_hand} = Repo.get(MatchPlayer, match_player.id)
      assert length(match_player_hand) == length(match_player.hand) - 1
      assert %{"value" => "2", "suit" => "clubs", "deck" => 1} not in match_player_hand
    end

    test "returns error when the previous event type is valid but made by other match player" do
      match = insert(:match, joker: %{"value" => "10", "suit" => "clubs", "deck" => 1})

      match_player =
        insert(:match_player, hand: [%{"value" => "2", "suit" => "clubs", "deck" => 1}])

      random_type = ["DROP_COLLECTION", "BUY", "ACCEPT_FIRST_CARD"] |> Enum.random()
      insert(:match_event, match: match, type: random_type)

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "DISCARD", [
                 %{"value" => "2", "suit" => "clubs", "deck" => 1}
               ])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when the discard card is not in match player cards" do
      match = insert(:match, joker: %{"value" => "10", "suit" => "clubs", "deck" => 1})

      match_player =
        insert(:match_player, hand: [%{"value" => "2", "suit" => "clubs", "deck" => 1}])

      random_type = ["DROP_COLLECTION", "BUY", "ACCEPT_FIRST_CARD"] |> Enum.random()
      insert(:match_event, match: match, match_player: match_player, type: random_type)

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "DISCARD", [
                 %{"value" => "2", "suit" => "diamonds", "deck" => 1}
               ])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when the discard card is the joker" do
      match = insert(:match, joker: %{"value" => "10", "suit" => "clubs", "deck" => 1})

      match_player =
        insert(:match_player, hand: [%{"value" => "10", "suit" => "clubs", "deck" => 1}])

      random_type = ["DROP_COLLECTION", "BUY", "ACCEPT_FIRST_CARD"] |> Enum.random()
      insert(:match_event, match: match, match_player: match_player, type: random_type)

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "DISCARD", [
                 %{"value" => "10", "suit" => "clubs", "deck" => 1}
               ])

      assert %{cards: ["you cannot discard the joker"]} = errors_on(changeset)
    end
  end

  describe "DROP_COLLECTION" do
    test "returns ok when previous event type is REPLACE_JOKER and the joker is in the dropped cards and collection is valid" do
      match = insert(:match, joker: %{"value" => "10", "suit" => "clubs", "deck" => 1})

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "clubs", "deck" => 1},
            %{"value" => "4", "suit" => "clubs", "deck" => 1},
            %{"value" => "10", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "REPLACE_JOKER")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "DROP_COLLECTION", [
                 %{"value" => "2", "suit" => "clubs", "deck" => 1},
                 %{"value" => "10", "suit" => "clubs", "deck" => 1},
                 %{"value" => "4", "suit" => "clubs", "deck" => 1}
               ])

      assert match_event.type == "DROP_COLLECTION"
      assert %MatchPlayer{hand: []} = Repo.get(MatchPlayer, match_player.id)
    end

    test "returns ok when previous event type is TAKE_DISCARD_PILE and the taked card is in the dropped cards and collection is valid" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "clubs", "deck" => 1},
            %{"value" => "4", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event,
        match: match,
        match_player: match_player,
        type: "TAKE_DISCARD_PILE",
        taked_card: %{"value" => "3", "suit" => "clubs", "deck" => 1}
      )

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "DROP_COLLECTION", [
                 %{"value" => "2", "suit" => "clubs", "deck" => 1},
                 %{"value" => "3", "suit" => "clubs", "deck" => 1},
                 %{"value" => "4", "suit" => "clubs", "deck" => 1}
               ])

      assert match_event.type == "DROP_COLLECTION"
      assert %MatchPlayer{hand: []} = Repo.get(MatchPlayer, match_player.id)
    end

    test "returns ok when previous event type and collection are valid" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "clubs", "deck" => 1},
            %{"value" => "3", "suit" => "clubs", "deck" => 1},
            %{"value" => "4", "suit" => "clubs", "deck" => 1}
          ]
        )

      random_type =
        ["BUY", "ASK_BEAT", "DROP_COLLECTION", "ADD_CARD_TO_COLLECTION"] |> Enum.random()

      insert(:match_event, match: match, match_player: match_player, type: random_type)

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "DROP_COLLECTION", [
                 %{"value" => "2", "suit" => "clubs", "deck" => 1},
                 %{"value" => "3", "suit" => "clubs", "deck" => 1},
                 %{"value" => "4", "suit" => "clubs", "deck" => 1}
               ])

      assert match_event.type == "DROP_COLLECTION"
      assert %MatchPlayer{hand: []} = Repo.get(MatchPlayer, match_player.id)
    end

    test "returns error when previous event type is REPLACE_JOKER and joker is not in the dropped cards" do
      match = insert(:match, joker: %{"value" => "10", "suit" => "clubs", "deck" => 1})

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "2", "suit" => "clubs", "deck" => 1},
            %{"value" => "4", "suit" => "clubs", "deck" => 1},
            %{"value" => "10", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "REPLACE_JOKER")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "DROP_COLLECTION", [
                 %{"value" => "2", "suit" => "clubs", "deck" => 1},
                 %{"value" => "3", "suit" => "clubs", "deck" => 1},
                 %{"value" => "4", "suit" => "clubs", "deck" => 1}
               ])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when previous event type is TAKE_DISCARD_PILE and the taked card is not in the dropped cards" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "4", "suit" => "clubs", "deck" => 1},
            %{"value" => "5", "suit" => "clubs", "deck" => 1},
            %{"value" => "6", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event,
        match: match,
        match_player: match_player,
        type: "TAKE_DISCARD_PILE",
        taked_card: %{"value" => "3", "suit" => "clubs", "deck" => 1}
      )

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "DROP_COLLECTION", [
                 %{"value" => "4", "suit" => "clubs", "deck" => 1},
                 %{"value" => "5", "suit" => "clubs", "deck" => 1},
                 %{"value" => "6", "suit" => "clubs", "deck" => 1}
               ])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when previous event type is invalid" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "4", "suit" => "clubs", "deck" => 1},
            %{"value" => "5", "suit" => "clubs", "deck" => 1},
            %{"value" => "6", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "DISCARD")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "DROP_COLLECTION", [
                 %{"value" => "4", "suit" => "clubs", "deck" => 1},
                 %{"value" => "5", "suit" => "clubs", "deck" => 1},
                 %{"value" => "6", "suit" => "clubs", "deck" => 1}
               ])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when collection is invalid" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "4", "suit" => "clubs", "deck" => 1},
            %{"value" => "5", "suit" => "clubs", "deck" => 1},
            %{"value" => "7", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "BUY")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "DROP_COLLECTION", [
                 %{"value" => "4", "suit" => "clubs", "deck" => 1},
                 %{"value" => "5", "suit" => "clubs", "deck" => 1},
                 %{"value" => "7", "suit" => "clubs", "deck" => 1}
               ])

      assert %{cards: ["invalid sequence"]} = errors_on(changeset)
    end

    test "returns error when the previous event was made by other match player" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "4", "suit" => "clubs", "deck" => 1},
            %{"value" => "5", "suit" => "clubs", "deck" => 1},
            %{"value" => "6", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, type: "BUY")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "DROP_COLLECTION", [
                 %{"value" => "4", "suit" => "clubs", "deck" => 1},
                 %{"value" => "5", "suit" => "clubs", "deck" => 1},
                 %{"value" => "6", "suit" => "clubs", "deck" => 1}
               ])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when the used cards are not present in match player hand" do
      match = insert(:match)

      match_player =
        insert(:match_player,
          hand: [
            %{"value" => "4", "suit" => "clubs", "deck" => 1},
            %{"value" => "5", "suit" => "clubs", "deck" => 1},
            %{"value" => "6", "suit" => "clubs", "deck" => 1}
          ]
        )

      insert(:match_event, match: match, match_player: match_player, type: "BUY")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "DROP_COLLECTION", [
                 %{"value" => "4", "suit" => "clubs", "deck" => 1},
                 %{"value" => "5", "suit" => "clubs", "deck" => 1},
                 %{"value" => "6", "suit" => "clubs", "deck" => 1},
                 %{"value" => "7", "suit" => "clubs", "deck" => 1}
               ])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "FALSE_BEAT" do
    test "returns ok when match player asked to beat" do
      match = insert(:match)
      match_player = insert(:match_player, false_beat: false)
      insert(:match_event, match: match, match_player: match_player, type: "ASK_BEAT")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "FALSE_BEAT", [])

      assert match_event.type == "FALSE_BEAT"

      assert %MatchPlayer{false_beat: true} = Repo.get(MatchPlayer, match_player.id)
    end

    test "returns error when match player did not ask to beat" do
      match = insert(:match)
      match_player = insert(:match_player, false_beat: false)
      insert(:match_event, match: match, match_player: match_player, type: "DISCARD")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "FALSE_BEAT", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "REJECT_FIRST_CARD" do
    test "returns ok when match player bought the first card" do
      match = insert(:match)
      match_player = insert(:match_player)

      insert(:match_event,
        match: match,
        match_player: match_player,
        type: "BUY_FIRST_CARD",
        taked_card: %{"value" => "2", "suit" => "clubs", "deck" => 1}
      )

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "REJECT_FIRST_CARD", [])

      assert match_event.type == "REJECT_FIRST_CARD"

      assert %{discard_pile: [%{"value" => "2", "suit" => "clubs", "deck" => 1} | _]} =
               Repo.get(Match, match.id)
    end

    test "returns error when previous event was not BUY_FIRST_CARD" do
      match = insert(:match)
      match_player = insert(:match_player, hand: [])
      insert(:match_event, match: match, match_player: match_player, type: "BUY")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 nil,
                 "REJECT_FIRST_CARD",
                 []
               )

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when the previous event was made by other match player" do
      match = insert(:match)
      match_player = insert(:match_player, hand: [])

      insert(:match_event,
        match: match,
        type: "BUY_FIRST_CARD",
        taked_card: %{"value" => "2", "suit" => "diamonds", "deck" => 1}
      )

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(
                 match,
                 match_player,
                 nil,
                 "REJECT_FIRST_CARD",
                 []
               )

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "REPLACE_JOKER" do
    test "returns ok when the match collection has a joker and match player has the replacement card" do
      match = insert(:match, joker: %{"value" => "2", "suit" => "clubs", "deck" => 1})

      match_player =
        insert(:match_player, hand: [%{"value" => "2", "suit" => "diamonds", "deck" => 1}])

      random_type =
        ["BUY", "ASK_BEAT", "DROP_COLLECTION", "ADD_CARD_TO_COLLECTION"] |> Enum.random()

      insert(:match_event, match: match, match_player: match_player, type: random_type)

      match_collection =
        insert(:match_collection,
          match: match,
          cards: [
            %{"value" => "A", "suit" => "diamonds", "deck" => 1},
            %{"value" => "2", "suit" => "clubs", "deck" => 1},
            %{"value" => "3", "suit" => "diamonds", "deck" => 1}
          ]
        )

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, match_collection, "REPLACE_JOKER", [
                 %{"value" => "2", "suit" => "diamonds", "deck" => 1}
               ])

      assert match_event.type == "REPLACE_JOKER"

      assert %MatchPlayer{hand: [%{"value" => "2", "suit" => "clubs", "deck" => 1}]} =
               Repo.get(MatchPlayer, match_player.id)

      assert %MatchCollection{
               cards: [
                 %{"value" => "A", "suit" => "diamonds", "deck" => 1},
                 %{"value" => "2", "suit" => "diamonds", "deck" => 1},
                 %{"value" => "3", "suit" => "diamonds", "deck" => 1}
               ]
             } = Repo.get(MatchCollection, match_collection.id)
    end

    test "returns error when the match collection has no joker" do
      match = insert(:match, joker: %{"value" => "2", "suit" => "clubs", "deck" => 1})

      match_player =
        insert(:match_player, hand: [%{"value" => "2", "suit" => "diamonds", "deck" => 1}])

      random_type =
        ["BUY", "ASK_BEAT", "DROP_COLLECTION", "ADD_CARD_TO_COLLECTION"] |> Enum.random()

      insert(:match_event, match: match, match_player: match_player, type: random_type)

      match_collection =
        insert(:match_collection,
          match: match,
          cards: [
            %{"value" => "A", "suit" => "diamonds", "deck" => 1},
            %{"value" => "2", "suit" => "diamonds", "deck" => 1},
            %{"value" => "3", "suit" => "diamonds", "deck" => 1}
          ]
        )

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, match_collection, "REPLACE_JOKER", [
                 %{"value" => "2", "suit" => "diamonds", "deck" => 1}
               ])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when the match player has no the replacement card" do
      match = insert(:match, joker: %{"value" => "2", "suit" => "clubs", "deck" => 1})

      match_player =
        insert(:match_player, hand: [%{"value" => "3", "suit" => "diamonds", "deck" => 1}])

      random_type =
        ["BUY", "ASK_BEAT", "DROP_COLLECTION", "ADD_CARD_TO_COLLECTION"] |> Enum.random()

      insert(:match_event, match: match, match_player: match_player, type: random_type)

      match_collection =
        insert(:match_collection,
          match: match,
          cards: [
            %{"value" => "A", "suit" => "diamonds", "deck" => 1},
            %{"value" => "2", "suit" => "clubs", "deck" => 1},
            %{"value" => "3", "suit" => "diamonds", "deck" => 1}
          ]
        )

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, match_collection, "REPLACE_JOKER", [
                 %{"value" => "3", "suit" => "diamonds", "deck" => 1}
               ])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end

  describe "TAKE_DISCARD_PILE" do
    test "returns ok when previous event type was DISCARD by other match player" do
      match =
        insert(:match,
          discard_pile: [
            %{"value" => "A", "suit" => "diamonds", "deck" => 1},
            %{"value" => "2", "suit" => "clubs", "deck" => 1}
          ]
        )

      match_player = insert(:match_player)
      insert(:match_event, match: match, type: "DISCARD")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "TAKE_DISCARD_PILE", [])

      assert match_event.type == "TAKE_DISCARD_PILE"
      assert match_event.taked_card == %{"value" => "A", "suit" => "diamonds", "deck" => 1}

      assert %Match{discard_pile: [%{"value" => "2", "suit" => "clubs", "deck" => 1}]} =
               Repo.get(Match, match.id)
    end

    test "returns ok when previous event type was ASK_BEAT by the same match player" do
      match =
        insert(:match,
          discard_pile: [
            %{"value" => "A", "suit" => "diamonds", "deck" => 1},
            %{"value" => "2", "suit" => "clubs", "deck" => 1}
          ]
        )

      match_player = insert(:match_player)
      insert(:match_event, match: match, match_player: match_player, type: "ASK_BEAT")

      assert {:ok, %MatchEvent{} = match_event} =
               CreateMatchEvent.run(match, match_player, nil, "TAKE_DISCARD_PILE", [])

      assert match_event.type == "TAKE_DISCARD_PILE"
      assert match_event.taked_card == %{"value" => "A", "suit" => "diamonds", "deck" => 1}

      assert %Match{discard_pile: [%{"value" => "2", "suit" => "clubs", "deck" => 1}]} =
               Repo.get(Match, match.id)
    end

    test "returns error when previous event type is invalid" do
      match =
        insert(:match,
          discard_pile: [
            %{"value" => "A", "suit" => "diamonds", "deck" => 1},
            %{"value" => "2", "suit" => "clubs", "deck" => 1}
          ]
        )

      match_player = insert(:match_player)
      insert(:match_event, match: match, match_player: match_player, type: "BUY")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "TAKE_DISCARD_PILE", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end

    test "returns error when match discard pile is empty" do
      match = insert(:match, discard_pile: [])
      match_player = insert(:match_player)
      insert(:match_event, match: match, match_player: match_player, type: "ASK_BEAT")

      assert {:error, %Ecto.Changeset{} = changeset} =
               CreateMatchEvent.run(match, match_player, nil, "TAKE_DISCARD_PILE", [])

      assert %{cards: ["invalid operation"]} = errors_on(changeset)
    end
  end
end
