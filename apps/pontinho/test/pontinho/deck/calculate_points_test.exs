defmodule Pontinho.CalculatePointsTest do
  use ExUnit.Case, async: true

  alias Pontinho.CalculatePoints

  setup do
    %{joker: %{"value" => "2", "suit" => "clubs"}}
  end

  test "returns 0 when cards is empty", %{joker: joker} do
    assert CalculatePoints.run([], joker) == 0
  end

  test "returns 20 when joker is present", %{joker: joker} do
    assert CalculatePoints.run([%{"value" => "2", "suit" => "clubs"}], joker) == 20
  end

  test "returns 10 when card is J, Q or K", %{joker: joker} do
    value = Enum.random(["J", "Q", "K"])
    assert CalculatePoints.run([%{"value" => value, "suit" => "clubs"}], joker) == 10
  end

  test "returns the card value when card is an integer value", %{joker: joker} do
    assert CalculatePoints.run([%{"value" => "2", "suit" => "diamonds"}], joker) == 2
    assert CalculatePoints.run([%{"value" => "3", "suit" => "diamonds"}], joker) == 3
    assert CalculatePoints.run([%{"value" => "4", "suit" => "diamonds"}], joker) == 4
    assert CalculatePoints.run([%{"value" => "5", "suit" => "diamonds"}], joker) == 5
    assert CalculatePoints.run([%{"value" => "6", "suit" => "diamonds"}], joker) == 6
    assert CalculatePoints.run([%{"value" => "7", "suit" => "diamonds"}], joker) == 7
    assert CalculatePoints.run([%{"value" => "8", "suit" => "diamonds"}], joker) == 8
    assert CalculatePoints.run([%{"value" => "9", "suit" => "diamonds"}], joker) == 9
    assert CalculatePoints.run([%{"value" => "10", "suit" => "diamonds"}], joker) == 10
  end

  test "returns the sum of points", %{joker: joker} do
    assert CalculatePoints.run(
             [
               %{"value" => "2", "suit" => "diamonds"},
               %{"value" => "2", "suit" => "clubs"},
               %{"value" => "A", "suit" => "diamonds"},
               %{"value" => "10", "suit" => "diamonds"},
               %{"value" => "J", "suit" => "diamonds"},
               %{"value" => "Q", "suit" => "diamonds"},
               %{"value" => "K", "suit" => "diamonds"}
             ],
             joker
           ) == 77
  end
end
