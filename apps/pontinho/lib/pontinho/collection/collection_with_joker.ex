defmodule Pontinho.CollectionWithJoker do
  @moduledoc """
  Validate collections with joker
  """

  alias Pontinho.Collection.ValidateSequence
  alias Pontinho.Deck

  @doc """
  It validates a collection that contains the match joker.

  For collections with one unique value, ignoring the joker, it is a trio, else it is a sequence.

  A trio with joker is valid if beat is true and if it has 2 or 3 suits, inclusing the joker suit.

  A sequence with joker is valid if the cards sequence is valid and the joker is not in the corners, except when beat is true.
  """
  @spec validate(list(map), integer(), integer(), integer(), map(), boolean()) ::
          {:ok, %{type: String.t()}} | {:error, String.t()}
  def validate(
        cards,
        cards_except_joker_values_length,
        cards_values_length,
        cards_suits_length,
        joker,
        beat
      ) do
    case cards_except_joker_values_length do
      1 ->
        validate_trio(cards_values_length, cards_suits_length, beat)

      _ ->
        validate_sequence(cards, joker, beat)
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

  defp validate_trio(cards_values_length, cards_suits_length, true = _beat) do
    cond do
      cards_values_length in [1, 2] && cards_suits_length in [2, 3] -> {:ok, %{type: "trio"}}
      true -> {:error, "invalid trio"}
    end
  end

  defp validate_trio(cards_values_length, cards_suits_length, false = _beat) do
    cond do
      cards_values_length == 1 && cards_suits_length == 3 -> {:ok, %{type: "trio"}}
      true -> {:error, "invalid trio"}
    end
  end
end
