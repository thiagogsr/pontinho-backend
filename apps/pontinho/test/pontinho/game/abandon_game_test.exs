defmodule Pontinho.AbandonGameTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.{AbandonGame, Player, Repo}

  test "updates the player broke times to 4 when it has less than 4 brokes" do
    player = insert(:player, broke_times: 0, playing: true, host: false)
    assert {:ok, %Player{broke_times: 4, playing: false}} = AbandonGame.run(player)
  end

  test "chooses a new host when the player is the host" do
    game = insert(:game)
    player1 = insert(:player, game: game, broke_times: 0, playing: true, host: true)
    player2 = insert(:player, game: game, playing: true, host: false)

    assert {:ok, %Player{broke_times: 4, playing: false, host: false}} = AbandonGame.run(player1)
    assert %Player{host: true} = Repo.get(Player, player2.id)
  end

  test "does not change the player broke times when it has greater or equals to 4 brokes" do
    player = insert(:player, broke_times: 4, playing: true, host: false)
    assert {:ok, %Player{broke_times: 4, playing: false}} = AbandonGame.run(player)

    player = insert(:player, broke_times: 5, playing: true, host: false)
    assert {:ok, %Player{broke_times: 5, playing: false}} = AbandonGame.run(player)
  end
end
