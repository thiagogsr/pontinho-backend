defmodule Pontinho.Event do
  @moduledoc """
  Event behavior
  """

  alias Pontinho.{Match, MatchCollection, MatchEvent, MatchPlayer}

  @callback validate(%Match{}, %MatchPlayer{}, %MatchCollection{}, list(map), %MatchEvent{}) ::
              list(String.t())
  @callback run(%Match{}, %MatchPlayer{}, %MatchCollection{}, list(map)) :: any
end
