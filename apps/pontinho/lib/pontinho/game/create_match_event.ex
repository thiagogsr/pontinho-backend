defmodule Pontinho.CreateMatchEvent do
  @moduledoc """
  Creating a match event
  """

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Pontinho.{HandleEvent, Match, MatchCollection, MatchEvent, MatchPlayer, Repo}

  @spec run(%Match{}, %MatchPlayer{}, %MatchCollection{}, String.t(), list(map)) ::
          {:ok, %MatchEvent{}} | {:error, %Ecto.Changeset{}}
  def run(match, match_player, match_collection, type, cards) do
    previous_event = get_last_match_event(match)

    match
    |> match_event_changeset(match_player, match_collection, type, cards, previous_event)
    |> Repo.insert()
  end

  defp get_last_match_event(%{id: match_id} = _match) do
    query =
      from(
        me in MatchEvent,
        where: me.match_id == ^match_id,
        order_by: [desc: me.inserted_at],
        limit: 1
      )

    Repo.one(query)
  end

  defp match_event_changeset(match, match_player, match_collection, type, cards, previous_event) do
    %MatchEvent{}
    |> cast(%{type: type, cards: cards}, [:type, :cards])
    |> put_assoc(:match, match)
    |> put_assoc(:match_player, match_player)
    |> put_assoc(:match_collection, match_collection)
    |> validate_match_event(match, match_player, match_collection, previous_event)
    |> prepare_changes(&prepare_side_effetcts(&1, match, match_player, match_collection))
  end

  defp validate_match_event(
         %Ecto.Changeset{valid?: true} = changeset,
         match,
         match_player,
         match_collection,
         previous_event
       ) do
    %{type: type, cards: cards} = changeset.changes

    case HandleEvent.validate(type, match, match_player, match_collection, cards, previous_event) do
      [] -> changeset
      errors -> Enum.reduce(errors, changeset, &add_error(&2, :cards, &1))
    end
  end

  defp validate_match_event(changeset, _match, _match_player, _match_collection, _previous_event),
    do: changeset

  defp prepare_side_effetcts(
         %Ecto.Changeset{valid?: true} = changeset,
         match,
         match_player,
         match_collection
       ) do
    %{type: type, cards: cards} = changeset.changes

    HandleEvent.run(type, match, match_player, match_collection, cards)
    changeset
  end

  defp prepare_side_effetcts(changeset, _match, _match_player, _match_collection), do: changeset
end
