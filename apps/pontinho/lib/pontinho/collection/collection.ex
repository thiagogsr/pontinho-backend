defmodule Pontinho.Collection do
  @moduledoc """
  Collection validator
  """

  alias Pontinho.{CollectionWithJoker, CollectionWithoutJoker}

  @spec validate(list(map), map, boolean) :: {:ok, %{type: String.t()}} | {:error, String.t()}
  def validate(cards, _joker, _beat) when length(cards) < 3 do
    {:error, "at least 3 cards"}
  end

  def validate(cards, joker, beat) do
    {values, suits} =
      Enum.reduce(cards, {[], []}, fn card, {values, suits} ->
        {[card["value"] | values], [card["suit"] | suits]}
      end)

    values = Enum.reverse(values)
    suits = Enum.reverse(suits)

    if joker in cards do
      CollectionWithJoker.validate(cards, values, suits, joker, beat)
    else
      CollectionWithoutJoker.validate(cards, values, suits)
    end
  end
end
