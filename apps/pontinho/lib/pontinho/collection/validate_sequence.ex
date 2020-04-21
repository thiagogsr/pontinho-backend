defmodule Pontinho.Collection.ValidateSequence do
  @moduledoc """
  Validating a sequence
  """

  alias Pontinho.Deck

  @two_index Deck.value_index("2")
  @ace_index Deck.value_index("A")
  @king_index Deck.value_index("K")

  @spec run(list(map), map | nil) :: :ok | :error
  def run(cards, joker \\ nil) do
    [first_card | tail_cards] = Enum.map(cards, &convert_card/1)
    joker_card = convert_card(joker)

    case validate(first_card, tail_cards, joker_card) do
      :error -> :error
      _ -> :ok
    end
  end

  defp convert_card(card) when is_nil(card), do: nil

  defp convert_card(card) do
    {Deck.value_index(card["value"]), card["suit"]}
  end

  defp validate(first_card, tail_cards, joker) do
    {first_index, _} = first_card

    Enum.reduce_while(tail_cards, first_card, fn {index, suit} = card, {past_index, _} ->
      cond do
        king_ace_two?(index, past_index, first_index) -> {:halt, :error}
        ace_after_king?(index, past_index) -> {:cont, card}
        greater_index?(index, past_index) -> {:cont, card}
        joker?(card, joker) -> {:cont, {past_index + 1, suit}}
        true -> {:halt, :error}
      end
    end)
  end

  defp king_ace_two?(current_index, past_index, first_index) do
    current_index == @two_index && past_index == @ace_index && first_index != @ace_index
  end

  defp ace_after_king?(current_index, past_index) do
    current_index == @ace_index && past_index == @king_index
  end

  defp greater_index?(current_index, past_index) do
    current_index - past_index == 1
  end

  defp joker?(current_card, joker) do
    !is_nil(joker) && current_card == joker
  end
end
