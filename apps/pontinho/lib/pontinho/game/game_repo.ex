defmodule Pontinho.GameRepo do
  @moduledoc """
  Game repository
  """

  alias Pontinho.{Game, Repo}

  @spec get_game!(String.t()) :: %Game{}
  def get_game!(game_id), do: Repo.get!(Game, game_id)
end
