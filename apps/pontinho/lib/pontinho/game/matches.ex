defmodule Pontinho.Matches do
  @moduledoc """
  Matches context
  """

  alias Pontinho.{Match, MatchPlayer}

  @spec find_match_player(%Match{}, Sting.t()) :: %MatchPlayer{} | nil
  def find_match_player(match, player_id) do
    Enum.find(match.match_players, &(&1.player_id == player_id))
  end
end
