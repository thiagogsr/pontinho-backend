defmodule Pontinho.CollectionWithoutJoker do
  @moduledoc """
  Validate collections without joker
  """

  alias Pontinho.Deck

  def validate(values, suits) do
    case values |> Enum.uniq() |> length() do
      1 -> validate_trio(suits)
      _ -> validate_sequence(values)
    end
  end

  defp validate_sequence(values) do
    [first_index | tail_indexes] = Enum.map(values, &Deck.value_index/1)

    case validate_sequence_order(first_index, tail_indexes) do
      :invalid -> {:error, "invalid sequence"}
      _ -> {:ok, %{type: "sequence"}}
    end
  end

  defp validate_sequence_order(first_index, tail_indexes) do
    two_index = Deck.value_index("2")
    ace_index = Deck.value_index("A")
    king_index = Deck.value_index("K")

    Enum.reduce_while(tail_indexes, first_index, fn index, last_index ->
      cond do
        # It avoids collection like "K, A, 2"
        index == two_index && last_index == ace_index && first_index != ace_index ->
          {:halt, :invalid}

        # It allows collection with "A" after "K"
        index == ace_index && last_index == king_index ->
          {:cont, index}

        index - last_index == 1 ->
          {:cont, index}

        true ->
          {:halt, :invalid}
      end
    end)
  end

  defp validate_trio(suits) do
    case suits |> Enum.uniq() |> length() do
      3 -> {:ok, %{type: "trio"}}
      _ -> {:error, "invalid trio"}
    end
  end
end
