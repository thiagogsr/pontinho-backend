defmodule Pontinho.CreateDeck do
  @moduledoc """
  Create the deck necessary for the game
  """

  @values ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
  @suits ["clubs", "diamonds", "hearts", "spades"]
  @shuffle_times 10

  @spec run() :: list(map)
  def run do
    @values
    |> Enum.map(fn value ->
      Enum.map(@suits, fn suit -> [%{value: value, suit: suit}, %{value: value, suit: suit}] end)
    end)
    |> List.flatten()
    |> shuffle(@shuffle_times)
  end

  defp shuffle(list, times) when times == 0, do: list

  defp shuffle(list, times) do
    list
    |> Enum.shuffle()
    |> shuffle(times - 1)
  end
end
