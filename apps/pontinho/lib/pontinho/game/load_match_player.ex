defmodule Pontinho.LoadMatchPlayer do
  @moduledoc """
  Load match player
  """

  import Ecto.Query, only: [from: 2]

  alias Pontinho.{MatchEvent, MatchPlayer, Repo}

  @spec run(%{match_id: String.t(), player_id: String.t()}) :: %{
          match_player: %MatchPlayer{} | nil,
          previous_event: %MatchEvent{} | nil
        }
  def run(%{match_id: match_id, player_id: player_id}) do
    match_id
    |> match_player_query(player_id)
    |> Repo.one()
    |> load_previous_event()
  end

  @spec run!(%{match_id: String.t(), player_id: String.t()}) :: %{
          match_player: %MatchPlayer{},
          previous_event: %MatchEvent{} | nil
        }
  def run!(%{match_id: match_id, player_id: player_id}) do
    match_id
    |> match_player_query(player_id)
    |> Repo.one!()
    |> load_previous_event()
  end

  @spec run!(%{match_player_id: String.t()}) :: %{
          match_player: %MatchPlayer{},
          asked_beat: boolean,
          taked_card: map() | nil
        }
  def run!(%{match_player_id: match_player_id}) do
    MatchPlayer
    |> Repo.get!(match_player_id)
    |> load_previous_event()
  end

  defp match_player_query(match_id, player_id) do
    from(
      mp in MatchPlayer,
      where: mp.match_id == ^match_id,
      where: mp.player_id == ^player_id,
      limit: 1
    )
  end

  defp load_previous_event(match_player) when is_nil(match_player) do
    %{match_player: nil, previous_event: nil}
  end

  defp load_previous_event(%{id: match_player_id} = match_player) do
    case load_last_match_event(match_player.match_id) do
      %MatchEvent{match_player_id: event_match_player_id} = match_event
      when event_match_player_id == match_player_id ->
        %{
          match_player: match_player,
          previous_event: match_event
        }

      _ ->
        %{match_player: match_player, previous_event: nil}
    end
  end

  defp load_last_match_event(match_id) do
    query =
      from(
        me in MatchEvent,
        where: me.match_id == ^match_id,
        order_by: [desc: me.inserted_at],
        limit: 1
      )

    Repo.one(query)
  end
end
