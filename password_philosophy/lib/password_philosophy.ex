defmodule PasswordPhilosophy do
  @doc ~S'''
      iex> input = """
      ...> 1-3 a: abcde
      ...> 1-3 b: cdefg
      ...> 2-9 c: ccccccccc
      ...> """
      ...> PasswordPhilosophy.check(input)
      2
  '''
  def check(input) do
    input
    |> parse()
    |> count_valid()
  end

  defp parse(input) do
    ~r/^(\d+)-(\d+) (\w): (\w+)$/ms
    |> Regex.scan(input, capture: :all_but_first)
  end

  defp count_valid(passwords), do: Enum.count(passwords, &valid?/1)

  defp valid?([min, max, letter, password]) do
    range = String.to_integer(min)..String.to_integer(max)
    (password |> String.graphemes() |> Enum.count(&(&1 == letter))) in range
  end
end
