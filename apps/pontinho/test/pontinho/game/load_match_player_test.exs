defmodule Pontinho.LoadMatchPlayerTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.LoadMatchPlayer

  test "returns the match player and the taked card when the last event was made by its" do
    match = insert(:match)
    player = insert(:player)
    match_player = insert(:match_player, match: match, player: player)

    insert(:match_event,
      match: match,
      match_player: match_player,
      taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}
    )

    assert %{match_player: returned_match_player, asked_beat: false, taked_card: taked_card} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert returned_match_player.id == match_player.id
    assert taked_card == %{"value" => "10", "suit" => "hearts", "deck" => 1}

    assert %{match_player: returned_match_player, asked_beat: false, taked_card: taked_card} =
             LoadMatchPlayer.run!(%{match_player_id: match_player.id})

    assert returned_match_player.id == match_player.id
    assert taked_card == %{"value" => "10", "suit" => "hearts", "deck" => 1}
  end

  test "returns the match player and asked beat when the last event was made by its and its type is ASK_BEAT" do
    match = insert(:match)
    player = insert(:player)
    match_player = insert(:match_player, match: match, player: player)
    insert(:match_event, match: match, match_player: match_player, type: "ASK_BEAT")

    assert %{match_player: returned_match_player, asked_beat: true, taked_card: nil} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert returned_match_player.id == match_player.id

    assert %{match_player: returned_match_player, asked_beat: true, taked_card: nil} =
             LoadMatchPlayer.run!(%{match_player_id: match_player.id})

    assert returned_match_player.id == match_player.id
  end

  test "returns the match player when the last event was made by its but it has no taked card" do
    match = insert(:match)
    player = insert(:player)
    match_player = insert(:match_player, match: match, player: player)
    insert(:match_event, match: match, match_player: match_player, taked_card: nil)

    assert %{match_player: returned_match_player, asked_beat: false, taked_card: nil} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert returned_match_player.id == match_player.id

    assert %{match_player: returned_match_player, asked_beat: false, taked_card: nil} =
             LoadMatchPlayer.run!(%{match_player_id: match_player.id})

    assert returned_match_player.id == match_player.id
  end

  test "returns the match player when the last event was not made by its" do
    match = insert(:match)
    player = insert(:player)
    match_player = insert(:match_player, match: match, player: player)

    insert(:match_event,
      match: match,
      taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}
    )

    assert %{match_player: returned_match_player, asked_beat: false, taked_card: nil} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert returned_match_player.id == match_player.id

    assert %{match_player: returned_match_player, asked_beat: false, taked_card: nil} =
             LoadMatchPlayer.run!(%{match_player_id: match_player.id})

    assert returned_match_player.id == match_player.id
  end

  test "returns the match player when there is not last event" do
    match = insert(:match)
    player = insert(:player)
    match_player = insert(:match_player, match: match, player: player)

    assert %{match_player: returned_match_player, asked_beat: false, taked_card: taked_card} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert returned_match_player.id == match_player.id
    assert is_nil(taked_card)

    assert %{match_player: returned_match_player, asked_beat: false, taked_card: taked_card} =
             LoadMatchPlayer.run!(%{match_player_id: match_player.id})

    assert returned_match_player.id == match_player.id
    assert is_nil(taked_card)
  end

  test "returns nothing when match player was not found" do
    match = insert(:match)
    player = insert(:player)

    assert %{match_player: nil, asked_beat: false, taked_card: nil} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert_raise Ecto.NoResultsError, fn ->
      LoadMatchPlayer.run!(%{match_id: match.id, player_id: player.id})
    end

    assert_raise Ecto.NoResultsError, fn ->
      LoadMatchPlayer.run!(%{match_player_id: player.id})
    end
  end
end
