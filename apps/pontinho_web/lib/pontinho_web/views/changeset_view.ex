defmodule PontinhoWeb.ChangesetView do
  use PontinhoWeb, :view

  def render("error.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}

    errors =
      changeset
      |> translate_errors()
      |> traverse_detail()
      |> List.flatten()

    %{errors: errors}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  defp traverse_detail(details) do
    Enum.map(details, fn {field, detail} ->
      cond do
        is_list(detail) -> serializer_detail({field, detail})
        is_map(detail) -> traverse_detail(detail)
        true -> %{}
      end
    end)
  end

  defp serializer_detail({field, detail}) do
    Enum.map(detail, fn title -> "#{field} #{title}" end)
  end
end
