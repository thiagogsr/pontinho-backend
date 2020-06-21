defmodule Pontinho.CollectionTest do
  use ExUnit.Case, async: 2

  alias Pontinho.Collection

  describe "validate/2" do
    test "returns error when there are less than 3 cards" do
      cards = [
        %{"value" => "2", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "hearts", "deck" => 1}
      ]

      joker = %{"value" => "A", "suit" => "hearts", "deck" => 1}

      assert {:error, "at least 3 cards"} = Collection.validate(cards, joker, true)
      assert {:error, "at least 3 cards"} = Collection.validate(cards, joker, false)
    end

    test "returns ok when it is a sequence without joker" do
      cards = [
        %{"value" => "A", "suit" => "hearts", "deck" => 1},
        %{"value" => "2", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "hearts", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, true)
      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, false)
    end

    test "returns ok when it is a sequence with a joker out of corners" do
      cards = [
        %{"value" => "A", "suit" => "hearts", "deck" => 1},
        %{"value" => "10", "suit" => "spades", "deck" => 1},
        %{"value" => "3", "suit" => "hearts", "deck" => 1}
      ]

      joker = %{"value" => "10", "suit" => "spades", "deck" => 2}

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, true)
      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, false)
    end

    test "returns ok when it is a sequence with a joker in the corner acting as a regular card" do
      cards = [
        %{"value" => "A", "suit" => "hearts", "deck" => 1},
        %{"value" => "2", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "hearts", "deck" => 1}
      ]

      joker = %{"value" => "A", "suit" => "hearts", "deck" => 1}

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, true)
      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, false)
    end

    test "validates sequence with a joker in the corner" do
      cards = [
        %{"value" => "A", "suit" => "hearts", "deck" => 1},
        %{"value" => "2", "suit" => "hearts", "deck" => 1},
        %{"value" => "10", "suit" => "spades", "deck" => 1}
      ]

      joker = %{"value" => "10", "suit" => "spades", "deck" => 1}

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, true)
      assert {:error, "joker cannot be in the corner"} = Collection.validate(cards, joker, false)
    end

    test "returns ok when it is a sequence with ACE after KING" do
      cards = [
        %{"value" => "Q", "suit" => "hearts", "deck" => 1},
        %{"value" => "K", "suit" => "hearts", "deck" => 1},
        %{"value" => "A", "suit" => "hearts", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, true)
      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, false)
    end

    test "returns ok when it is a sequence with joker and other card with the same value" do
      cards = [
        %{"value" => "10", "suit" => "suits", "deck" => 1},
        %{"value" => "10", "suit" => "hearts", "deck" => 1},
        %{"value" => "Q", "suit" => "suits", "deck" => 1}
      ]

      joker = %{"value" => "10", "suit" => "hearts", "deck" => 1}

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, true)
      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, false)
    end

    test "returns error when there are duplicated cards" do
      cards = [
        %{"value" => "A", "suit" => "hearts", "deck" => 1},
        %{"value" => "A", "suit" => "hearts", "deck" => 1},
        %{"value" => "2", "suit" => "hearts", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, true)
      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, false)
    end

    test "returns error when the sequence is unordered" do
      cards = [
        %{"value" => "3", "suit" => "hearts", "deck" => 1},
        %{"value" => "2", "suit" => "hearts", "deck" => 1},
        %{"value" => "A", "suit" => "hearts", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, true)
      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, false)
    end

    test "returns error when the sequence is K, A, 2" do
      cards = [
        %{"value" => "K", "suit" => "hearts", "deck" => 1},
        %{"value" => "A", "suit" => "hearts", "deck" => 1},
        %{"value" => "2", "suit" => "hearts", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, true)
      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, false)
    end

    test "returns error when the sequence is unordered with joker" do
      cards = [
        %{"value" => "J", "suit" => "hearts", "deck" => 1},
        %{"value" => "K", "suit" => "spades", "deck" => 1},
        %{"value" => "A", "suit" => "hearts", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, true)
      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, false)
    end

    test "returns error when the sequence has different suits" do
      cards = [
        %{"value" => "4", "suit" => "hearts", "deck" => 1},
        %{"value" => "5", "suit" => "spades", "deck" => 1},
        %{"value" => "6", "suit" => "spades", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, true)
      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, false)
    end

    test "returns ok then it is a trio without a joker" do
      cards = [
        %{"value" => "3", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "spades", "deck" => 1},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, true)
      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, false)
    end

    test "returns ok then it is a trio with joker acting as a regular card" do
      cards = [
        %{"value" => "3", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "spades", "deck" => 1},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1}
      ]

      joker = %{"value" => "3", "suit" => "hearts", "deck" => 1}

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, true)
      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, false)
    end

    test "returns ok then it is a trio without a joker and four cards" do
      cards = [
        %{"value" => "3", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "spades", "deck" => 1},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, true)
      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, false)
    end

    test "validates trio with a joker" do
      cards = [
        %{"value" => "3", "suit" => "hearts", "deck" => 1},
        %{"value" => "K", "suit" => "spades", "deck" => 1},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 2}

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, true)
      assert {:error, "invalid trio"} = Collection.validate(cards, joker, false)
    end

    test "validates trio with four cards and one of them is the joker" do
      cards = [
        %{"value" => "3", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "spades", "deck" => 1},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1},
        %{"value" => "K", "suit" => "spades", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 2}

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, true)
      assert {:error, "invalid trio"} = Collection.validate(cards, joker, false)
    end

    test "validates trio with duplicated cards and joker" do
      cards = [
        %{"value" => "3", "suit" => "spades", "deck" => 1},
        %{"value" => "3", "suit" => "spades", "deck" => 1},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1}
      ]

      joker = %{"value" => "3", "suit" => "spades", "deck" => 1}

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, true)
      assert {:error, "invalid trio"} = Collection.validate(cards, joker, false)
    end

    test "returns error when it is a trio with duplicated cards" do
      cards = [
        %{"value" => "3", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:error, "invalid trio"} = Collection.validate(cards, joker, true)
      assert {:error, "invalid trio"} = Collection.validate(cards, joker, false)
    end

    test "returns error when there are four suits" do
      cards = [
        %{"value" => "3", "suit" => "hearts", "deck" => 1},
        %{"value" => "3", "suit" => "spades", "deck" => 1},
        %{"value" => "3", "suit" => "diamonds", "deck" => 1},
        %{"value" => "3", "suit" => "clubs", "deck" => 1}
      ]

      joker = %{"value" => "K", "suit" => "spades", "deck" => 1}

      assert {:error, "invalid trio"} = Collection.validate(cards, joker, true)
      assert {:error, "invalid trio"} = Collection.validate(cards, joker, false)
    end
  end
end
