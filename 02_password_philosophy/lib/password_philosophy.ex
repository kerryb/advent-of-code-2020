defmodule PasswordPhilosophy do
  @moduledoc """
  https://adventofcode.com/2020/day/2
  """

  @doc ~S'''
      iex> input = """
      ...> 1-3 a: abcde
      ...> 1-3 b: cdefg
      ...> 2-9 c: ccccccccc
      ...> """
      ...> PasswordPhilosophy.check_sled(input)
      2
  '''
  def check_sled(input) do
    input
    |> parse()
    |> count_valid(&valid_sled?/1)
  end

  @doc ~S'''
      iex> input = """
      ...> 1-3 a: abcde
      ...> 1-3 b: cdefg
      ...> 2-9 c: ccccccccc
      ...> """
      ...> PasswordPhilosophy.check_toboggan(input)
      1
  '''
  def check_toboggan(input) do
    input
    |> parse()
    |> count_valid(&valid_toboggan?/1)
  end

  defp parse(input) do
    ~r/^(\d+)-(\d+) (\w): (\w+)$/ms
    |> Regex.scan(input, capture: :all_but_first)
  end

  defp count_valid(passwords, checker), do: Enum.count(passwords, checker)

  defp valid_sled?([min, max, letter, password]) do
    range = String.to_integer(min)..String.to_integer(max)
    (password |> String.graphemes() |> Enum.count(&(&1 == letter))) in range
  end

  defp valid_toboggan?([index_1, index_2, letter, password]) do
    Enum.count(
      [
        String.at(password, String.to_integer(index_1) - 1),
        String.at(password, String.to_integer(index_2) - 1)
      ],
      &(&1 == letter)
    ) == 1
  end
end
