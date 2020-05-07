defmodule Pontinho.GameRepo do
  @moduledoc """
  Game repository
  """

  alias Pontinho.{Game, Player, Repo}

  @spec get_game!(String.t()) :: %Game{}
  def get_game!(game_id), do: Repo.get!(Game, game_id)

  @spec list_players(%Game{}) :: list(%Player{})
  def list_players(game), do: game |> Ecto.assoc(:players) |> Repo.all()
end
