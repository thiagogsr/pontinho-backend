defmodule Pontinho.LoadMatchPlayerTest do
  use Pontinho.DataCase, async: true

  import Pontinho.Factory

  alias Pontinho.LoadMatchPlayer

  test "returns the match player and previous event when it was made by the match player" do
    match = insert(:match)
    player = insert(:player)
    match_player = insert(:match_player, match: match, player: player)

    insert(:match_event,
      match: match,
      match_player: match_player,
      type: "BUY_FIRST_CARD",
      taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}
    )

    assert %{match_player: returned_match_player, previous_event: previous_event} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert returned_match_player.id == match_player.id
    assert %{taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}} = previous_event

    assert %{match_player: returned_match_player, previous_event: previous_event} =
             LoadMatchPlayer.run!(%{match_player_id: match_player.id})

    assert returned_match_player.id == match_player.id
    assert %{taked_card: %{"value" => "10", "suit" => "hearts", "deck" => 1}} = previous_event
  end

  test "returns the match player when the previous event was made by other match player" do
    match = insert(:match)
    player = insert(:player)
    match_player = insert(:match_player, match: match, player: player)
    insert(:match_event, match: match)

    assert %{match_player: returned_match_player, previous_event: previous_event} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert returned_match_player.id == match_player.id
    assert is_nil(previous_event)

    assert %{match_player: returned_match_player, previous_event: previous_event} =
             LoadMatchPlayer.run!(%{match_player_id: match_player.id})

    assert returned_match_player.id == match_player.id
    assert is_nil(previous_event)
  end

  test "returns the match player when there is not previous event" do
    match = insert(:match)
    player = insert(:player)
    match_player = insert(:match_player, match: match, player: player)

    assert %{match_player: returned_match_player, previous_event: previous_event} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert returned_match_player.id == match_player.id
    assert is_nil(previous_event)

    assert %{match_player: returned_match_player, previous_event: previous_event} =
             LoadMatchPlayer.run!(%{match_player_id: match_player.id})

    assert returned_match_player.id == match_player.id
    assert is_nil(previous_event)
  end

  test "returns nothing when match player was not found" do
    match = insert(:match)
    player = insert(:player)

    assert %{match_player: nil, previous_event: nil} =
             LoadMatchPlayer.run(%{match_id: match.id, player_id: player.id})

    assert_raise Ecto.NoResultsError, fn ->
      LoadMatchPlayer.run!(%{match_id: match.id, player_id: player.id})
    end

    assert_raise Ecto.NoResultsError, fn ->
      LoadMatchPlayer.run!(%{match_player_id: player.id})
    end
  end
end
