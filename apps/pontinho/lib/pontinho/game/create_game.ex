defmodule Pontinho.CreateGame do
  @moduledoc """
  Create a new game
  """

  alias Pontinho.{Game, Repo}

  import Ecto.Changeset

  @spec run(list(pos_integer)) :: {:ok, %Game{}} | {:error, %Ecto.Changeset{}}
  def run(betting_table) do
    %Game{}
    |> change()
    |> put_change(:betting_table, betting_table)
    |> validate_length(:betting_table, min: 5, max: 11)
    |> validate_change(:betting_table, fn :betting_table, betting_table ->
      if Enum.all?(betting_table, &is_integer/1) do
        []
      else
        [betting_table: "should be a list of integer"]
      end
    end)
    |> Repo.insert()
  end
end
