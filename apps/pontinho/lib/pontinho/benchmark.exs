keys = Enum.to_list(1..13)
values = Enum.to_list(1..4)

Benchee.run(%{
  "flat_map" => fn ->
    Enum.flat_map(keys, fn key ->
      Enum.flat_map(values, fn value -> [%{key: key, value: value}, %{key: key, value: value}] end)
    end)
  end,
  "map.flatten" => fn ->
    keys
    |> Enum.map(fn key ->
      Enum.map(values, fn value -> [%{key: key, value: value}, %{key: key, value: value}] end)
    end)
    |> List.flatten()
  end
})
