defmodule Pontinho.MatchCollectionRepo do
  @moduledoc """
  Match collection repository
  """

  alias Pontinho.{MatchCollection, Repo}

  @spec get_match_collection(String.t()) :: %MatchCollection{} | nil
  def get_match_collection(match_collection_id) do
    Repo.get(MatchCollection, match_collection_id)
  end
end
