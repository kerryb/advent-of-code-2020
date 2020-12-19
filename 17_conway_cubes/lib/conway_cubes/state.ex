defmodule ConwayCubes.State do
  defstruct [:x, :y, :z, :active]

  def from_text(text) do
    active =
      text
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index()
      |> Enum.flat_map(&build_row/1)
      |> Enum.reject(&is_nil/1)
      |> MapSet.new()

    {min_x, max_x} = active |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = active |> Enum.map(&elem(&1, 1)) |> Enum.min_max()
    {min_z, max_z} = active |> Enum.map(&elem(&1, 2)) |> Enum.min_max()
    %__MODULE__{x: min_x..max_x, y: min_y..max_y, z: min_z..max_z, active: active}
  end

  defp build_row({row, y}), do: Enum.map(row, &add_if_active(&1, y))

  defp add_if_active({"#", x}, y), do: {x, y, 0}
  defp add_if_active(_, _), do: nil

  def advance(%{x: min_x..max_x, y: min_y..max_y, z: min_z..max_z, active: active} = state) do
    new_x = (min_x - 1)..(max_x + 1)
    new_y = (min_y - 1)..(max_y + 1)
    new_z = (min_z - 1)..(max_z + 1)

    new_active =
      for x <- new_x, y <- new_y, z <- new_z do
        {x, y, z, MapSet.member?(active, {x, y, z}), active}
      end
      |> Enum.reduce(active, &update_cube/2)

    %{state | x: new_x, y: new_y, z: new_z, active: new_active}
  end

  defp update_cube({x, y, z, true, active_cubes}, updated_active_cubes) do
    {x, y, z}
    |> neigbours()
    |> Enum.count(&MapSet.member?(active_cubes, &1))
    |> case do
      n when n in [2, 3] -> updated_active_cubes
      _ -> MapSet.delete(updated_active_cubes, {x, y, z})
    end
  end

  defp update_cube({x, y, z, false, active_cubes}, updated_active_cubes) do
    {x, y, z}
    |> neigbours()
    |> Enum.count(&MapSet.member?(active_cubes, &1))
    |> case do
      3 -> MapSet.put(updated_active_cubes, {x, y, z})
      _ -> updated_active_cubes
    end
  end

  def neigbours({x, y, z}) do
    for xx <- (x - 1)..(x + 1),
        yy <- (y - 1)..(y + 1),
        zz <- (z - 1)..(z + 1),
        {xx, yy, zz} != {x, y, z} do
      {xx, yy, zz}
    end
  end
end
