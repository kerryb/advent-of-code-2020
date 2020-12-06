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
      ...> CustomCustoms.count_any(input)
      11
  '''
  def count_any(input) do
    input
    |> parse()
    |> count_group_answers()
    |> Enum.sum()
  end

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
      ...> CustomCustoms.count_all(input)
      6
  '''
  def count_all(input) do
    input
    |> parse()
    |> parse_groups()
    |> count_group_common_answers()
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.split("\n\n")
  end

  defp parse_groups(groups), do: Enum.map(groups, &parse_group/1)

  defp parse_group(group) do
    group
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp count_group_answers(answers), do: Enum.map(answers, &count_unique/1)

  defp count_unique(answers) do
    answers
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.count(&(&1 != "\n"))
  end

  defp count_group_common_answers(answers), do: Enum.map(answers, &count_common/1)

  defp count_common(group) do
    group
    |> Enum.reduce(&common_answers/2)
    |> Enum.count()
  end

  defp common_answers(a, b) do
    Enum.filter(a, &(&1 in b))
  end
end
