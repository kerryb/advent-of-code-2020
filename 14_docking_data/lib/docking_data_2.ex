defmodule DockingData2 do
  @moduledoc """
  https://adventofcode.com/2020/day/14#part2
  """

  use Bitwise

  @doc ~S'''
      iex> input = """
      ...> mask = 000000000000000000000000000000X1001X
      ...> mem[42] = 100
      ...> mask = 00000000000000000000000000000000X0XX
      ...> mem[26] = 1
      ...> """
      ...> DockingData.run(input)
      165
  '''
  def run(input) do
    input
    |> parse()
    |> execute()
    |> total()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line("mask = " <> mask) do
  end

  defp parse_line(line) do
  end

  defp execute(instructions) do
    Enum.reduce(instructions, {%{}, nil, nil}, &execute_instruction/2)
  end

  defp total({memory, _, _}) do
    memory
    |> Map.values()
    |> Enum.sum()
  end
end
