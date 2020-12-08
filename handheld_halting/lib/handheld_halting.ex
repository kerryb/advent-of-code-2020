defmodule HandheldHalting do
  @moduledoc """
  https://adventofcode.com/2020/day/8
  """

  @doc ~S'''
      iex> input = """
      ...> nop +0
      ...> acc +1
      ...> jmp +4
      ...> acc +3
      ...> jmp -3
      ...> acc -99
      ...> acc +1
      ...> jmp -4
      ...> acc +6
      ...> """
      ...> HandheldHalting.run(input)
      5
  '''
  def run(input) do
    input
    |> parse()
    |> execute_until_repeat()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.into(%{}, &parse_line/1)
  end

  defp parse_line({<<instruction::binary-size(3), " ", argument::binary>>, index}) do
    {index, %{instruction: instruction, argument: String.to_integer(argument), executed?: false}}
  end

  defp execute_until_repeat(program, pointer \\ 0, acc \\ 0) do
    case program[pointer] do
      %{executed?: true} ->
        acc

      %{instruction: "nop"} ->
        execute_until_repeat(put_in(program[pointer].executed?, true), pointer + 1, acc)

      %{instruction: "acc", argument: argument} ->
        execute_until_repeat(
          put_in(program[pointer].executed?, true),
          pointer + 1,
          acc + argument
        )

      %{instruction: "jmp", argument: argument} ->
        execute_until_repeat(put_in(program[pointer].executed?, true), pointer + argument, acc)
    end
  end
end
