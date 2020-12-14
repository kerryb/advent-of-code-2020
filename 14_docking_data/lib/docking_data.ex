defmodule DockingData do
  @moduledoc """
  https://adventofcode.com/2020/day/14
  """

  use Bitwise

  @doc ~S'''
      iex> input = """
      ...> mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      ...> mem[8] = 11
      ...> mem[7] = 101
      ...> mem[8] = 0
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
    {:mask, and_mask(mask), or_mask(mask)}
  end

  defp parse_line(line) do
    [address, value] = Regex.run(~r/\[(\d+)\] = (\d+)/, line, capture: :all_but_first)
    {:write, String.to_integer(address), String.to_integer(value)}
  end

  defp and_mask(mask) do
    mask
    |> String.replace("X", "1")
    |> String.to_integer(2)
  end

  defp or_mask(mask) do
    mask
    |> String.replace("X", "0")
    |> String.to_integer(2)
  end

  defp execute(instructions) do
    Enum.reduce(instructions, {%{}, nil, nil}, &execute_instruction/2)
  end

  defp execute_instruction({:mask, and_mask, or_mask}, {memory, _, _}) do
    {memory, and_mask, or_mask}
  end

  defp execute_instruction({:write, address, value}, {memory, and_mask, or_mask}) do
    {Map.put(memory, address, (value &&& and_mask) ||| or_mask), and_mask, or_mask}
  end

  defp total({memory, _, _}) do
    memory
    |> Map.values()
    |> Enum.sum()
  end
end
