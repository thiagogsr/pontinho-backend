defmodule PontinhoWeb.MatchChannel do
  @moduledoc """
  Match channel
  """

  use PontinhoWeb, :channel

  alias PontinhoWeb.{ChangesetView, MatchPlayerSerializer, MatchSerializer}

  intercept ["refresh"]

  def join("match:" <> match_id, _, %{assigns: %{player: player}} = socket) do
    case Pontinho.load_match_player(%{match_id: match_id, player_id: player.id}) do
      %{match_player: nil} ->
        {:error, %{reason: "unauthorized"}}

      _match_player ->
        {:ok, socket}
    end
  end

  def handle_in("match_event", payload, %{assigns: %{player: player}} = socket) do
    %{topic: "match:" <> match_id} = socket

    type = Map.get(payload, "type")
    cards = Map.get(payload, "cards", [])

    match = Pontinho.get_match!(match_id)
    match_player = Pontinho.find_match_player!(match_id, player.id)

    match_collection =
      case Map.get(payload, "match_collection_id") do
        nil -> nil
        match_collection_id -> Pontinho.get_match_collection(match_collection_id)
      end

    case Pontinho.create_match_event(match, match_player, match_collection, type, cards) do
      {:ok, %{type: "BEAT"} = _match_event} ->
        broadcast!(socket, "beat", %{player_name: match_player.player.name})
        {:reply, :ok, socket}

      {:ok, _match_event} ->
        reloaded_match = Pontinho.load_match(match_id)
        serialized_match = MatchSerializer.serialize(reloaded_match)
        broadcast!(socket, "refresh", %{match: serialized_match})
        {:reply, :ok, socket}

      {:error, changeset} ->
        changeset_view = ChangesetView.render("error.json", %{changeset: changeset})
        {:reply, {:error, changeset_view}, socket}
    end
  end

  def handle_out("refresh", msg, %{assigns: %{player: player}} = socket) do
    %{topic: "match:" <> match_id} = socket

    match_player = Pontinho.load_match_player!(%{match_id: match_id, player_id: player.id})
    serialized_match_player = MatchPlayerSerializer.serialize(match_player)

    new_msg = Map.merge(msg, %{match_player: serialized_match_player})
    push(socket, "refresh", new_msg)

    {:noreply, socket}
  end
end
