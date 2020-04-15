defmodule Pontinho.CollectionWithJoker do
  @moduledoc """
  Validate collections with joker
  """

  alias Pontinho.Deck

  def validate(values, suits, joker, beat) do
    case values |> Enum.uniq() |> length() do
      length when length in [1, 2] -> validate_trio(suits, beat)
      _ -> validate_sequence(values, suits, joker, beat)
    end
  end

  defp validate_sequence(values, suits, joker, beat) do
    [first_card | tail_cards] =
      values
      |> Enum.map(&Deck.value_index/1)
      |> Enum.zip(suits)

    joker_card = {Deck.value_index(joker.value), joker.suit}
    last_card = List.last(tail_cards)

    with :ok <- validate_sequence_joker(first_card, last_card, joker_card, beat),
         card when is_tuple(card) <- validate_sequence_order(first_card, tail_cards, joker_card) do
      {:ok, %{type: "sequence"}}
    end
  end

  defp validate_sequence_joker(first_card, last_card, joker_card, beat) do
    if !beat && joker_card in [first_card, last_card] do
      {:error, "joker cannot be in the corner"}
    else
      :ok
    end
  end

  defp validate_sequence_order(first_card, tail_cards, joker_card) do
    {first_index, _first_suit} = first_card
    two_index = Deck.value_index("2")
    ace_index = Deck.value_index("A")
    king_index = Deck.value_index("K")

    Enum.reduce_while(tail_cards, first_card, fn {index, _suit} = card,
                                                 {last_index, _last_suit} = last ->
      cond do
        # It avoids collection like "K, A, 2"
        index == two_index && last_index == ace_index && first_index != ace_index ->
          {:halt, :invalid}

        # It allows collection with "A" after "K"
        index == ace_index && last_index == king_index ->
          {:cont, index}

        index - last_index == 1 ->
          {:cont, card}

        card == joker_card || last == joker_card ->
          {:cont, joker_card}

        true ->
          {:halt, {:error, "invalid sequence"}}
      end
    end)
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
