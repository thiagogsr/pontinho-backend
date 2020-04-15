defmodule Pontinho.CollectionTest do
  use ExUnit.Case, async: 2

  alias Pontinho.Collection

  describe "validate/2" do
    test "returns error when there are less than 3 cards" do
      cards = [%{value: "2", suit: "hearts"}, %{value: "3", suit: "hearts"}]
      joker = %{value: "A", suit: "hearts"}
      beat = false

      assert {:error, "at least 3 cards"} = Collection.validate(cards, joker, beat)
    end

    test "returns ok when it is a sequence without joker" do
      cards = [
        %{value: "A", suit: "hearts"},
        %{value: "2", suit: "hearts"},
        %{value: "3", suit: "hearts"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, beat)
    end

    test "returns ok when it is a sequence with a joker out of corners" do
      cards = [
        %{value: "A", suit: "hearts"},
        %{value: "10", suit: "spades"},
        %{value: "3", suit: "hearts"}
      ]

      joker = %{value: "10", suit: "spades"}
      beat = false

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, beat)
    end

    test "returns ok when it is a sequence with a joker in the corner and player beats" do
      cards = [
        %{value: "A", suit: "hearts"},
        %{value: "2", suit: "hearts"},
        %{value: "10", suit: "spades"}
      ]

      joker = %{value: "10", suit: "spades"}
      beat = true

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, beat)
    end

    test "returns ok when it is a sequence with ACE after KING" do
      cards = [
        %{value: "Q", suit: "hearts"},
        %{value: "K", suit: "hearts"},
        %{value: "A", suit: "hearts"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:ok, %{type: "sequence"}} = Collection.validate(cards, joker, beat)
    end

    test "returns error when it is a sequence with a joker in the corner and player does not beat" do
      cards = [
        %{value: "A", suit: "hearts"},
        %{value: "2", suit: "hearts"},
        %{value: "10", suit: "spades"}
      ]

      joker = %{value: "10", suit: "spades"}
      beat = false

      assert {:error, "joker cannot be in the corner"} = Collection.validate(cards, joker, beat)
    end

    test "returns error when there are duplicated cards" do
      cards = [
        %{value: "A", suit: "hearts"},
        %{value: "A", suit: "hearts"},
        %{value: "2", suit: "hearts"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, beat)
    end

    test "returns error when the sequence is unordered" do
      cards = [
        %{value: "3", suit: "hearts"},
        %{value: "2", suit: "hearts"},
        %{value: "A", suit: "hearts"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, beat)
    end

    test "returns error when the sequence is K, A, 2" do
      cards = [
        %{value: "K", suit: "hearts"},
        %{value: "A", suit: "hearts"},
        %{value: "2", suit: "hearts"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:error, "invalid sequence"} = Collection.validate(cards, joker, beat)
    end

    test "returns ok then it is a trio without a joker" do
      cards = [
        %{value: "3", suit: "hearts"},
        %{value: "3", suit: "spades"},
        %{value: "3", suit: "diamonds"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, beat)
    end

    test "returns ok then it is a trio without a joker and four cards" do
      cards = [
        %{value: "3", suit: "hearts"},
        %{value: "3", suit: "spades"},
        %{value: "3", suit: "diamonds"},
        %{value: "3", suit: "diamonds"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, beat)
    end

    test "returns ok then it is a trio with a joker and player beats" do
      cards = [
        %{value: "3", suit: "hearts"},
        %{value: "K", suit: "spades"},
        %{value: "3", suit: "diamonds"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = true

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, beat)
    end

    test "returns ok when there are four cards and one of them is the joker and player beats" do
      cards = [
        %{value: "3", suit: "hearts"},
        %{value: "3", suit: "spades"},
        %{value: "3", suit: "diamonds"},
        %{value: "K", suit: "spades"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = true

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, beat)
    end

    test "returns ok when there are duplicated cards for a trio with joker and player beats" do
      cards = [
        %{value: "3", suit: "spades"},
        %{value: "3", suit: "spades"},
        %{value: "3", suit: "diamonds"}
      ]

      joker = %{value: "3", suit: "spades"}
      beat = true

      assert {:ok, %{type: "trio"}} = Collection.validate(cards, joker, beat)
    end

    test "returns error when it is a trio with duplicated cards" do
      cards = [
        %{value: "3", suit: "hearts"},
        %{value: "3", suit: "hearts"},
        %{value: "3", suit: "diamonds"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:error, "invalid trio"} = Collection.validate(cards, joker, beat)
    end

    test "returns error when it is a trio with a joker and player does not beat" do
      cards = [
        %{value: "3", suit: "hearts"},
        %{value: "K", suit: "spades"},
        %{value: "3", suit: "diamonds"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:error, "invalid trio"} = Collection.validate(cards, joker, beat)
    end

    test "returns error when there are four suits" do
      cards = [
        %{value: "3", suit: "hearts"},
        %{value: "3", suit: "spades"},
        %{value: "3", suit: "diamonds"},
        %{value: "3", suit: "clubs"}
      ]

      joker = %{value: "K", suit: "spades"}
      beat = false

      assert {:error, "invalid trio"} = Collection.validate(cards, joker, beat)
    end
  end
end
