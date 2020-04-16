defmodule Pontinho.CollectionWithoutJoker do
  @moduledoc """
  Validate collections without joker
  """

  alias Pontinho.Collection.ValidateSequence

  def validate(cards, values, suits) do
    case values |> Enum.uniq() |> length() do
      1 -> validate_trio(suits)
      _ -> validate_sequence(cards)
    end
  end

  defp validate_sequence(cards) do
    case ValidateSequence.run(cards) do
      :ok -> {:ok, %{type: "sequence"}}
      :error -> {:error, "invalid sequence"}
    end
  end

  defp validate_trio(suits) do
    case suits |> Enum.uniq() |> length() do
      3 -> {:ok, %{type: "trio"}}
      _ -> {:error, "invalid trio"}
    end
  end
end
