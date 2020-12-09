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
    |> elem(1)
  end

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
      ...> HandheldHalting.fix_and_run(input)
      8
  '''
  def fix_and_run(input) do
    program = parse(input)

    program
    |> Map.keys()
    |> Enum.find_value(&fix_at_index(&1, program))
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
      nil ->
        {:finished, acc}

      %{executed?: true} ->
        {:loop, acc}

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

  defp fix_at_index(index, program) do
    program[index]
    |> case do
      %{instruction: "nop"} -> execute_until_repeat(put_in(program[index].instruction, "jmp"))
      %{instruction: "jmp"} -> execute_until_repeat(put_in(program[index].instruction, "nop"))
      _ -> false
    end
    |> case do
      {:finished, acc} -> acc
      _ -> false
    end
  end
end
