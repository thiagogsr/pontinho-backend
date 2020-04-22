defmodule Pontinho.AbandonGameTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.{AbandonGame, Player}

  test "updates the player broke times to 4 when it has less than 4 brokes" do
    player = insert(:player, broke_times: 0, playing: true)
    assert {:ok, %Player{broke_times: 4, playing: false}} = AbandonGame.run(player)
  end

  test "does not change the player broke times when it has greater or equals to 4 brokes" do
    player = insert(:player, broke_times: 4, playing: true)
    assert {:ok, %Player{broke_times: 4, playing: false}} = AbandonGame.run(player)

    player = insert(:player, broke_times: 5, playing: true)
    assert {:ok, %Player{broke_times: 5, playing: false}} = AbandonGame.run(player)
  end
end
