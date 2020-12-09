defmodule EncodingError do
  @moduledoc """
  https://adventofcode.com/2020/day/9
  """

  @doc ~S'''
      iex> input = """
      ...> 35
      ...> 20
      ...> 15
      ...> 25
      ...> 47
      ...> 40
      ...> 62
      ...> 55
      ...> 65
      ...> 95
      ...> 102
      ...> 117
      ...> 150
      ...> 182
      ...> 127
      ...> 219
      ...> 299
      ...> 277
      ...> 309
      ...> 576
      ...> """
      ...> EncodingError.find_error(input, 5)
      127
  '''
  def find_error(input, window \\ 25) do
    input
    |> parse()
    |> find_first_error(window)
  end

  @doc ~S'''
      iex> input = """
      ...> 35
      ...> 20
      ...> 15
      ...> 25
      ...> 47
      ...> 40
      ...> 62
      ...> 55
      ...> 65
      ...> 95
      ...> 102
      ...> 117
      ...> 150
      ...> 182
      ...> 127
      ...> 219
      ...> 299
      ...> 277
      ...> 309
      ...> 576
      ...> """
      ...> EncodingError.find_sequence(input, 5)
      62
  '''
  def find_sequence(input, window \\ 25) do
    numbers = parse(input)
    total = find_first_error(numbers, window)

    numbers
    |> find_matching_sequence(total)
    |> add_smallest_and_largest()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp find_first_error(numbers, window) do
    numbers
    |> Enum.chunk_every(window + 1, 1, :discard)
    |> Enum.find_value(&invalid?/1)
  end

  defp invalid?(numbers) do
    {preamble, [number]} = Enum.split(numbers, -1)
    if find_matching_pair(preamble, number), do: false, else: number
  end

  defp find_matching_pair([], _number), do: false

  defp find_matching_pair([head | tail], number) do
    tail |> Enum.filter(&(head + &1 == number))
    Enum.any?(tail, &(head + &1 == number)) or find_matching_pair(tail, number)
  end

  defp find_matching_sequence(numbers, total) do
    case Enum.reduce_while(numbers, {0, []}, &sum_until_reaches(&1, &2, total)) do
      false -> find_matching_sequence(tl(numbers), total)
      sequence -> sequence
    end
  end

  defp sum_until_reaches(number, {sum, sequence}, total) do
    case number + sum do
      ^total -> {:halt, sequence}
      n when n > total -> {:halt, false}
      n -> {:cont, {n, [number | sequence]}}
    end
  end

  defp add_smallest_and_largest(sequence) do
    Enum.min(sequence) + Enum.max(sequence)
  end
end
