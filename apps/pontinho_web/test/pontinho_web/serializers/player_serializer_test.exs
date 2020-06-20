defmodule PontinhoWeb.PlayerSerializerTest do
  use ExUnit.Case, async: true

  import Pontinho.Factory

  alias PontinhoWeb.PlayerSerializer

  describe "serialize/1" do
    test "returns a serialized player" do
      player = build(:player, name: "Player", points: 99, playing: true)

      assert PlayerSerializer.serialize(player) == %{
               id: nil,
               name: "Player",
               points: 99,
               playing: true
             }
    end
  end
end
