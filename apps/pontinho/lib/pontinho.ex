defmodule Pontinho do
  @moduledoc """
  Pontinho API
  """

  defdelegate create_game(betting_table), to: Pontinho.CreateGame, as: :run
  defdelegate join_game(game, player_name), to: Pontinho.JoinGame, as: :run
end
