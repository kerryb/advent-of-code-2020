defmodule BinaryBoarding do
  @doc ~S'''
      iex> input = """
      ...> BFFFBBFRRR
      ...> FFFBBBFRRR
      ...> BBFFBBFRLL
      ...> """
      ...> BinaryBoarding.highest_seat(input)
      820
  '''
  def highest_seat(input) do
    input
    |> parse()
    |> decode()
    |> generate_ids()
    |> Enum.max()
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
end
