defmodule Pontinho.CreateDeck do
  @moduledoc """
  Create the deck necessary for the game
  """

  alias Pontinho.Deck

  @shuffle_times Application.get_env(:pontinho, :deck_shuffle_times)

  @spec run() :: list(map)
  def run do
    Deck.values()
    |> Enum.map(fn value ->
      Enum.map(Deck.suits(), fn suit ->
        [%{value: value, suit: suit}, %{value: value, suit: suit}]
      end)
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
