defmodule Pontinho do
  @moduledoc """
  Pontinho API
  """

  defdelegate create_game(betting_table), to: Pontinho.CreateGame, as: :run
  defdelegate join_game(game, player_name), to: Pontinho.JoinGame, as: :run
  defdelegate get_game!(game_id), to: Pontinho.GameRepo
  defdelegate list_players(game), to: Pontinho.GameRepo
  defdelegate list_game_matches(game), to: Pontinho.GameMatches, as: :list
  defdelegate get_player(player_id), to: Pontinho.PlayerRepo
  defdelegate start_match(game), to: Pontinho.StartMatch, as: :run
  defdelegate get_match!(match_id), to: Pontinho.MatchRepo
  defdelegate find_match_player(match_id, player_id), to: Pontinho.MatchPlayerRepo
  defdelegate get_match_player!(match_player_id), to: Pontinho.MatchPlayerRepo
end
