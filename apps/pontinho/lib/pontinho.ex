defmodule Pontinho do
  @moduledoc """
  Pontinho API
  """

  defdelegate create_game(betting_table), to: Pontinho.CreateGame, as: :run
  defdelegate join_game(game, player_name), to: Pontinho.JoinGame, as: :run
  defdelegate get_game!(game_id), to: Pontinho.GameRepo
  defdelegate list_players(game), to: Pontinho.GameRepo
  defdelegate list_game_matches(game), to: Pontinho.GameMatches, as: :list
end
