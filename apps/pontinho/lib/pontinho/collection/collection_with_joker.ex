defmodule Pontinho.CollectionWithJoker do
  @moduledoc """
  Validate collections with joker
  """

  alias Pontinho.Collection.ValidateSequence
  alias Pontinho.Deck

  def validate(cards, values, suits, joker, beat) do
    case values |> Enum.uniq() |> length() do
      length when length in [1, 2] -> validate_trio(suits, beat)
      _ -> validate_sequence(cards, joker, beat)
    end
  end

  defp validate_sequence(cards, joker, beat) do
    first_card = List.first(cards)
    last_card = List.last(cards)

    with :ok <- validate_sequence_joker(first_card, last_card, joker, beat) do
      case ValidateSequence.run(cards, joker) do
        :ok -> {:ok, %{type: "sequence"}}
        :error -> {:error, "invalid sequence"}
      end
    end
  end

  defp validate_sequence_joker(first_card, last_card, joker, beat) do
    if !beat && Deck.member?([first_card, last_card], joker) do
      {:error, "joker cannot be in the corner"}
    else
      :ok
    end
  end

  defp validate_trio(suits, true = _beat) do
    case suits |> Enum.uniq() |> length() do
      1 -> {:error, "invalid trio"}
      _ -> {:ok, %{type: "trio"}}
    end
  end

  defp validate_trio(_suits, false = _beat) do
    {:error, "invalid trio"}
  end
end
