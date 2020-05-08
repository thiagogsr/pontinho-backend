defmodule Pontinho.GameRepo do
  @moduledoc """
  Game repository
  """

  import Ecto.Query, only: [from: 2]

  alias Pontinho.{Game, Player, Repo}

  @spec get_game!(String.t()) :: %Game{}
  def get_game!(game_id), do: Repo.get!(Game, game_id)

  @spec list_players(%Game{}) :: list(%Player{})
  def list_players(game) do
    game
    |> Repo.preload(players: from(p in Player, order_by: p.sequence))
    |> Map.get(:players)
  end
end
