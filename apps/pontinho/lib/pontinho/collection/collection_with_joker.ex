defmodule Pontinho.CollectionWithJoker do
  @moduledoc """
  Validate collections with joker
  """

  alias Pontinho.Collection.ValidateSequence
  alias Pontinho.Deck

  def validate(cards, values, suits, joker, beat) do
    case values |> Enum.uniq() |> length() do
      values_length when values_length in [1, 2] -> validate_trio(values_length, suits, beat)
      _ -> validate_sequence(cards, joker, beat)
    end
  end

  defp validate_sequence(cards, joker, beat) do
    first_card = List.first(cards)
    last_card = List.last(cards)

    case ValidateSequence.run(cards, joker) do
      :ok_with_joker ->
        with :ok <- validate_sequence_joker(first_card, last_card, joker, beat) do
          {:ok, %{type: "sequence"}}
        end

      :ok_without_joker ->
        {:ok, %{type: "sequence"}}

      _ ->
        {:error, "invalid sequence"}
    end
  end

  defp validate_sequence_joker(first_card, last_card, joker, beat) do
    if !beat && Deck.member?([first_card, last_card], joker) do
      {:error, "joker cannot be in the corner"}
    else
      :ok
    end
  end

  defp validate_trio(values_length, _suits, false = _beat) when values_length == 2 do
    {:error, "invalid trio"}
  end

  defp validate_trio(_values_length, suits, true = _beat) do
    case suits |> Enum.uniq() |> length() do
      suits_length when suits_length in [2, 3] -> {:ok, %{type: "trio"}}
      _ -> {:error, "invalid trio"}
    end
  end

  defp validate_trio(_values_length, suits, false = _beat) do
    case suits |> Enum.uniq() |> length() do
      3 -> {:ok, %{type: "trio"}}
      _ -> {:error, "invalid trio"}
    end
  end
end
