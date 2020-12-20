defmodule OperationOrder do
  @moduledoc """
  https://adventofcode.com/2020/day/18
  """

  def evaluate(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&evaluate_line/1)
    |> Enum.sum()
  end

  defp evaluate_line(line) do
    line
    |> substitute()
    |> evaluate_no_parens()
  end

  def evaluate_no_parens(expr) do
    expr
    |> String.split(" ")
    |> Enum.reverse()
    |> reduce()
  end

  defp reduce([a]), do: String.to_integer(a)
  defp reduce([a, "+" | tail]), do: String.to_integer(a) + reduce(tail)
  defp reduce([a, "*" | tail]), do: String.to_integer(a) * reduce(tail)

  def substitute(expression) do
    if String.contains?(expression, "(") do
      ~r/\(([^()]+)\)/
      |> Regex.replace(expression, fn _, subexpr ->
        subexpr |> evaluate_no_parens() |> to_string()
      end)
      |> substitute()
    else
      expression
    end
  end
end
