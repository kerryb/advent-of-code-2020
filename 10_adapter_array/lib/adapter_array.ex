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

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp find_differences(ratings) do
    built_in = Enum.max(ratings) + 3

    [0, built_in | ratings]
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  defp count_1s_and_3s(differences) do
    [Enum.count(differences, &(&1 == 1)), Enum.count(differences, &(&1 == 3))]
  end
end
