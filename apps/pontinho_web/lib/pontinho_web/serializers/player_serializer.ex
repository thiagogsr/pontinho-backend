defmodule PontinhoWeb.PlayerSerializer do
  @moduledoc """
  Player serializer
  """

  @spec serialize(map) :: map
  def serialize(player) do
    %{
      id: player.id,
      name: player.name,
      points: player.points,
      playing: player.playing
    }
  end
end
