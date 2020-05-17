defmodule Pontinho.MatchRepo do
  @moduledoc """
  Match repository
  """

  alias Pontinho.{Match, Repo}

  @spec get_match!(String.t()) :: %Match{}
  def get_match!(match_id) do
    Repo.get!(Match, match_id)
  end
end
