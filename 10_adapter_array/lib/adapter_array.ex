defmodule AdapterArray do
  @moduledoc """
  https://adventofcode.com/2020/day/10
  """

  @doc ~S'''
      iex> input = """
      ...> 16
      ...> 10
      ...> 15
      ...> 5
      ...> 1
      ...> 11
      ...> 7
      ...> 19
      ...> 6
      ...> 12
      ...> 4
      ...> """
      ...> AdapterArray.solve(input)
      35
  '''
  def solve(input) do
    input
    |> parse()
    |> find_differences()
    |> count_1s_and_3s()
    |> Enum.reduce(&*/2)
  end

  @doc ~S'''
      iex> input = """
      ...> 16
      ...> 10
      ...> 15
      ...> 5
      ...> 1
      ...> 11
      ...> 7
      ...> 19
      ...> 6
      ...> 12
      ...> 4
      ...> """
      ...> AdapterArray.count_combinations(input)
      8
  '''
  def count_combinations(input) do
    input
    |> parse()
    |> sort_with_outlet_and_built_in_adapter()
    |> count_valid_combinations()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp find_differences(ratings) do
    ratings
    |> sort_with_outlet_and_built_in_adapter()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  defp count_1s_and_3s(differences) do
    [Enum.count(differences, &(&1 == 1)), Enum.count(differences, &(&1 == 3))]
  end

  defp sort_with_outlet_and_built_in_adapter(ratings) do
    built_in = Enum.max(ratings) + 3
    Enum.sort([0, built_in | ratings])
  end

  defp count_valid_combinations([]), do: 0
  defp count_valid_combinations([_]), do: 1

  defp count_valid_combinations([head | tail]) do
    valid_count = tail |> Enum.take_while(&(&1 - head <= 3)) |> Enum.count()

    0..(valid_count-1)
    |> Enum.reduce(0, fn index, acc -> acc + count_valid_combinations(Enum.drop(tail, index)) end)
  end
end
