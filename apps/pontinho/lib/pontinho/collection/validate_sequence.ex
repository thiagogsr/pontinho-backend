defmodule Pontinho.Collection.ValidateSequence do
  @moduledoc """
  Validating a sequence
  """

  alias Pontinho.Deck

  @two_index Deck.value_index("2")
  @ace_index Deck.value_index("A")
  @king_index Deck.value_index("K")

  @doc """
  Returns:
    * :ok_with_joker when joker is present in cards and it is used as joker
    * :ok_without_joker when joker is present in cards but acting as a regular card or when it is not present
    * :error when the sequence is not valid
  """
  @spec run(list(map), map | nil) :: :ok_with_joker | :ok_without_joker | :error
  def run(cards, joker \\ nil) do
    with :ok <- validate_suits(cards, joker) do
      case validate_values(cards, joker) do
        :error -> :error
        %{with_joker: true} -> :ok_with_joker
        %{with_joker: false} -> :ok_without_joker
      end
    end
  end

  defp validate_suits(cards, joker) when is_nil(joker) do
    case Enum.uniq_by(cards, & &1["suit"]) do
      suits when length(suits) == 1 -> :ok
      _ -> :error
    end
  end

  defp validate_suits(cards, joker) do
    suits =
      cards
      |> Enum.reject(&(&1["value"] == joker["value"] && &1["suit"] == joker["suit"]))
      |> Enum.uniq_by(& &1["suit"])

    if length(suits) == 1 do
      :ok
    else
      :error
    end
  end

  defp validate_values(cards, joker) do
    [first_card | tail_cards] = Enum.map(cards, &convert_card/1)
    {first_index, _} = first_card
    joker_card = convert_card(joker)

    Enum.reduce_while(tail_cards, %{card: first_card, with_joker: false}, fn card, acc ->
      {index, suit} = card
      %{card: {past_index, _}, with_joker: with_joker} = acc

      cond do
        king_ace_two?(index, past_index, first_index) -> {:halt, :error}
        ace_after_king?(index, past_index) -> {:cont, %{card: card, with_joker: with_joker}}
        greater_index?(index, past_index) -> {:cont, %{card: card, with_joker: with_joker}}
        joker?(card, joker_card) -> {:cont, %{card: {past_index + 1, suit}, with_joker: true}}
        true -> {:halt, :error}
      end
    end)
  end

  defp convert_card(card) when is_nil(card), do: nil

  defp convert_card(card) do
    {Deck.value_index(card["value"]), card["suit"]}
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
