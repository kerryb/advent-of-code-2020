defmodule SeatingSystem do
  @moduledoc """
  https://adventofcode.com/2020/day/11
  """

  @doc ~S'''
      iex> input = """
      ...> L.LL.LL.LL
      ...> LLLLLLL.LL
      ...> L.L.L..L..
      ...> LLLL.LL.LL
      ...> L.LL.LL.LL
      ...> L.LLLLL.LL
      ...> ..L.L.....
      ...> LLLLLLLLLL
      ...> L.LLLLLL.L
      ...> L.LLLLL.LL
      ...> """
      ...> SeatingSystem.model_occupied_seats(input)
      37
  '''
  def model_occupied_seats(input) do
    input
    |> parse
    |> model_until_stable()
    |> Map.values()
    |> Enum.count(& &1)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{})
  end

  defp parse_row({row, column_index}) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(&seat(&1, column_index))
  end

  defp seat({".", _}, _), do: nil
  defp seat({"L", row_index}, column_index), do: {{row_index, column_index}, false}
  defp seat({"#", row_index}, column_index), do: {{row_index, column_index}, true}

  defp model_until_stable(seats) do
    seats
    |> Map.keys()
    |> Enum.into(%{}, &update(&1, seats))
    |> case do
      ^seats -> seats
      new_seats -> model_until_stable(new_seats)
    end
  end

  defp update(position, seats) do
    state =
      position
      |> neighbours()
      |> Enum.map(&seats[&1])
      |> new_state(seats[position])

    {position, state}
  end

  defp neighbours({x, y}) do
    for dx <- [-1, 0, 1], dy <- [-1, 0, 1], dx != 0 or dy != 0 do
      {x + dx, y + dy}
    end
  end

  defp new_state(neighbours, state) do
    case {state, Enum.count(neighbours, & &1)} do
      {false, 0} -> true
      {true, n} when n >= 4 -> false
      _ -> state
    end
  end
end
