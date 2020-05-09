defmodule Pontinho.ShuffleCards do
  @moduledoc """
  Shuffle cards
  """

  @shuffle_times Application.get_env(:pontinho, :cards_shuffle_times)

  @spec run(list(map), integer()) :: list(map)
  def run(list, times \\ @shuffle_times)

  def run(list, times) when times == 0, do: list

  def run(list, times) do
    list
    |> Enum.shuffle()
    |> run(times - 1)
  end
end
