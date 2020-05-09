defmodule Pontinho.HandleEvent do
  @moduledoc """
  Handling an event by type
  """

  alias Pontinho.{Match, MatchCollection, MatchEvent, MatchPlayer}

  alias Pontinho.Event.{
    AcceptFirstCard,
    AddCardToCollection,
    AskBeat,
    Beat,
    Buy,
    BuyFirstCard,
    Discard,
    DropCollection,
    FalseBeat,
    RejectFirstCard,
    ReplaceJoker,
    TakeDiscardPile
  }

  @mapping %{
    "ACCEPT_FIRST_CARD" => AcceptFirstCard,
    "ADD_CARD_TO_COLLECTION" => AddCardToCollection,
    "ASK_BEAT" => AskBeat,
    "BEAT" => Beat,
    "BUY_FIRST_CARD" => BuyFirstCard,
    "BUY" => Buy,
    "DISCARD" => Discard,
    "DROP_COLLECTION" => DropCollection,
    "FALSE_BEAT" => FalseBeat,
    "REJECT_FIRST_CARD" => RejectFirstCard,
    "REPLACE_JOKER" => ReplaceJoker,
    "TAKE_DISCARD_PILE" => TakeDiscardPile
  }

  @spec validate(
          String.t(),
          %Match{},
          %MatchPlayer{},
          %MatchCollection{},
          list(map),
          %MatchEvent{}
        ) :: list(String.t())
  def validate(type, match, match_player, match_collection, cards, previous_event) do
    apply(@mapping[type], :validate, [
      match,
      match_player,
      match_collection,
      cards,
      previous_event
    ])
  end

  @spec run(String.t(), %Match{}, %MatchPlayer{}, %MatchCollection{}, list(map), %MatchEvent{}) ::
          {:cast, atom(), any()} | any()
  def run(type, match, match_player, match_collection, cards, previous_event) do
    apply(@mapping[type], :run, [match, match_player, match_collection, cards, previous_event])
  end
end
