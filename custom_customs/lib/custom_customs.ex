defmodule CustomCustoms do
  @moduledoc """
  https://adventofcode.com/2020/day/6
  """

  @doc ~S'''
      iex> input = """
      ...> abc
      ...>
      ...> a
      ...> b
      ...> c
      ...>
      ...> ab
      ...> ac
      ...>
      ...> a
      ...> a
      ...> a
      ...> a
      ...>
      ...> b
      ...> """
      ...> CustomCustoms.count(input)
      11
  '''
  def count(input) do
    input
    |> parse()
    |> count_group_answers()
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.split("\n\n")
  end

  defp count_group_answers(answers), do: Enum.map(answers, &count_unique/1)

  defp count_unique(answers) do
    answers
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.count(&(&1 != "\n"))
  end
end
