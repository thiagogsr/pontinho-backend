defmodule Pontinho.MatchPlayerRepo do
  @moduledoc """
  Match player repository
  """

  import Ecto.Query, only: [from: 2]

  alias Pontinho.{MatchPlayer, Repo}

  @spec find_match_player!(String.t(), String.t()) :: %MatchPlayer{} | nil
  def find_match_player!(match_id, player_id) do
    from(
      mp in MatchPlayer,
      where: mp.match_id == ^match_id,
      where: mp.player_id == ^player_id,
      limit: 1
    )
    |> Repo.one!()
  end

  @spec get_match_player!(String.t()) :: %MatchPlayer{}
  def get_match_player!(match_player_id) do
    Repo.get!(MatchPlayer, match_player_id)
  end
end
