defmodule Pontinho.CalculatePoints do
  @moduledoc """
  Calculate points for cards
  """

  @spec run(list(map), map) :: non_neg_integer()
  def run(cards, joker) do
    Enum.reduce(cards, 0, &calculate(&1, &2, joker))
  end

  defp calculate(card, points, joker) when card == joker, do: points + 20
  defp calculate(%{"value" => "A", "suit" => _}, points, _), do: points + 15

  defp calculate(%{"value" => value, "suit" => _}, points, _) when value in ["J", "Q", "K"] do
    points + 10
  end

  defp calculate(%{"value" => value, "suit" => _}, points, _) do
    points + String.to_integer(value)
  end
end
