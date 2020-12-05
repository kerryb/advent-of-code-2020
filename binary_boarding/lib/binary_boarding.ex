defmodule BinaryBoarding do
  @moduledoc """
  https://adventofcode.com/2020/day/5
  """

  def highest_seat(input) do
    input
    |> get_seat_ids()
    |> Enum.max()
  end

  def find_seat(input) do
    input
    |> get_seat_ids()
    |> find_gap()
  end

  @doc ~S'''
      iex> input = """
      ...> BFFFBBFRRR
      ...> FFFBBBFRRR
      ...> BBFFBBFRLL
      ...> """
      ...> BinaryBoarding.get_seat_ids(input)
      [567, 119, 820]
  '''
  def get_seat_ids(input) do
    input
    |> parse()
    |> decode()
    |> generate_ids()
  end

  defp parse(input) do
    String.split(input, "\n", trim: true)
  end

  defp decode(code) do
    Enum.map(code, &decode(&1, {0..127, 0..7}))
  end

  defp decode("", {row..row, column..column}), do: {row, column}

  defp decode("F" <> tail, {first..last, column}) do
    decode(tail, {first..(first + div(last - first, 2)), column})
  end

  defp decode("B" <> tail, {first..last, column}) do
    decode(tail, {(first + div(last - first + 1, 2))..last, column})
  end

  defp decode("L" <> tail, {row, first..last}) do
    decode(tail, {row, first..(first + div(last - first, 2))})
  end

  defp decode("R" <> tail, {row, first..last}) do
    decode(tail, {row, (first + div(last - first + 1, 2))..last})
  end

  defp generate_ids(seats), do: Enum.map(seats, &generate_id/1)
  defp generate_id({row, column}), do: row * 8 + column

  @doc """
      iex> BinaryBoarding.find_gap([6, 4, 8, 5, 9])
      7
  """
  def find_gap(ids) do
    ids
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.find_value(fn [a, b] -> if b - a == 2, do: a + 1, else: false end)
  end
end
