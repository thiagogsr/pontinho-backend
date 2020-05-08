defmodule Pontinho.PlayerRepo do
  @moduledoc """
  Player repository
  """

  alias Pontinho.{Player, Repo}

  @spec get_player(String.t()) :: %Player{} | nil
  def get_player(player_id), do: Repo.get(Player, player_id)
end
