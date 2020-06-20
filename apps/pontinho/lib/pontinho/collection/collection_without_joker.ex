defmodule Pontinho.CollectionWithoutJoker do
  @moduledoc """
  Validate collections without joker
  """

  alias Pontinho.Collection.ValidateSequence

  @doc """
  It validates a collection that does not contain the match joker.

  For collections with one unique value, it is a trio, else it is a sequence.

  A trio without joker is valid if it has 3 suits.

  A sequence without joker is valid if the cards sequence is valid.
  """
  @spec validate(list(map), integer(), integer()) ::
          {:ok, %{type: String.t()}} | {:error, String.t()}
  def validate(cards, values_length, suits_length) do
    case values_length do
      1 -> validate_trio(suits_length)
      _ -> validate_sequence(cards)
    end
  end

  defp validate_sequence(cards) do
    case ValidateSequence.run(cards) do
      :ok_without_joker -> {:ok, %{type: "sequence"}}
      :error -> {:error, "invalid sequence"}
    end
  end

  defp validate_trio(suits_length) do
    case suits_length do
      3 -> {:ok, %{type: "trio"}}
      _ -> {:error, "invalid trio"}
    end
  end
end
