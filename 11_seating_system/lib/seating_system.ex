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
      ...> SeatingSystem.model_adjacent_seats(input)
      37
  '''
  def model_adjacent_seats(input) do
    input
    |> parse
    |> model_until_stable(&update_by_adjacent_neighbours/2)
    |> Map.values()
    |> Enum.count(&(&1 == :occupied))
  end

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
      ...> SeatingSystem.model_nearest_seats(input)
      26
  '''
  def model_nearest_seats(input) do
    input
    |> parse
    |> model_until_stable(&update_by_nearest_neighbours/2)
    |> Map.values()
    |> Enum.count(&(&1 == :occupied))
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row/1)
    |> Enum.into(%{})
  end

  defp parse_row({row, column_index}) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(&seat(&1, column_index))
  end

  defp seat({".", row_index}, column_index), do: {{row_index, column_index}, :floor}
  defp seat({"L", row_index}, column_index), do: {{row_index, column_index}, :empty}
  defp seat({"#", row_index}, column_index), do: {{row_index, column_index}, :occupied}

  defp model_until_stable(seats, update_fn) do
    seats
    |> Map.keys()
    |> Enum.into(%{}, &update(&1, seats, update_fn))
    |> case do
      ^seats -> seats
      new_seats -> model_until_stable(new_seats, update_fn)
    end
  end

  defp update(position, seats, update_fn) do
    {position, update_fn.(position, seats)}
  end

  defp update_by_adjacent_neighbours({x, y}, seats) do
    for dx <- [-1, 0, 1], dy <- [-1, 0, 1], dx != 0 or dy != 0 do
      seats[{x + dx, y + dy}]
    end
    |> new_state(seats[{x, y}], 4)
  end

  defp update_by_nearest_neighbours({x, y}, seats) do
    for dx <- [-1, 0, 1], dy <- [-1, 0, 1], dx != 0 or dy != 0 do
      first_seat_in_direction({x, y}, {dx, dy}, seats)
    end
    |> new_state(seats[{x, y}], 5)
  end

  defp first_seat_in_direction({x, y}, {dx, dy}, seats, distance \\ 1) do
    case seats[{x + dx * distance, y + dy * distance}] do
      nil -> :empty
      :floor -> first_seat_in_direction({x, y}, {dx, dy}, seats, distance + 1)
      seat -> seat
    end
  end

  defp new_state(neighbours, state, neighbour_limit) do
    case {state, Enum.count(neighbours, &(&1 == :occupied))} do
      {:empty, 0} -> :occupied
      {:occupied, n} when n >= neighbour_limit -> :empty
      _ -> state
    end
  end
end
