defmodule Pontinho.CalculatePoints do
  @moduledoc """
  Calculate points for cards
  """

  @spec run(list(map), map) :: non_neg_integer()
  def run(cards, joker) do
    Enum.reduce(cards, 0, &calculate(&1, &2, joker))
  end

  defp calculate(card, points, joker) do
    cond do
      card["value"] == joker["value"] && card["suit"] == joker["suit"] -> points + 20
      card["value"] == "A" -> points + 15
      card["value"] in ["J", "Q", "K"] -> points + 10
      true -> points + String.to_integer(card["value"])
    end
  end
end
