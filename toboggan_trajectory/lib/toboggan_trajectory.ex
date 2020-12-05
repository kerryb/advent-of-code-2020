defmodule TobogganTrajectory do
  @moduledoc """
  https://adventofcode.com/2020/day/3
  """

  @doc ~S'''
  iex> input = """
  ...> ..##.......
  ...> #...#...#..
  ...> .#....#..#.
  ...> ..#.#...#.#
  ...> .#...##..#.
  ...> ..#.##.....
  ...> .#.#.#....#
  ...> .#........#
  ...> #.##...#...
  ...> #...##....#
  ...> .#..#...#.#
  ...> """
  ...> TobogganTrajectory.count_trees(input, 1, 1)
  2
  iex> TobogganTrajectory.count_trees(input, 3, 1)
  7
  iex> TobogganTrajectory.count_trees(input, 5, 1)
  3
  iex> TobogganTrajectory.count_trees(input, 7, 1)
  4
  iex> TobogganTrajectory.count_trees(input, 1, 2)
  2
  '''
  def count_trees(input, right, down) do
    input
    |> parse()
    |> travel(right, down, 0)
  end

  def count_trees_for_multiple_paths(input) do
    for {right, down} <- [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}] do
      count_trees(input, right, down)
    end
    |> Enum.reduce(&*/2)
  end

  defp parse(input), do: String.split(input, "\n", trim: true)

  defp travel(rows, right, down, index) do
    case Enum.drop(rows, down) do
      [] ->
        0

      remaining_rows ->
        new_index = index + right

        if(tree?(remaining_rows, new_index), do: 1, else: 0) +
          travel(remaining_rows, right, down, new_index)
    end
  end

  defp tree?([row | _], index) do
    String.at(row, Integer.mod(index, String.length(row))) == "#"
  end
end
