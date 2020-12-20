defmodule MonsterMessages do
  @moduledoc """
  https://adventofcode.com/2020/day/19
  """

  def count_matching_messages(input) do
    data = parse(input)
    pattern = build_pattern(data.rules)
    Enum.count(data.messages, & &1 =~ pattern)
  end
  def parse(input) do
    [rule_input, message_input] = String.split(input, "\n\n")

    %{
      rules: parse_rules(rule_input),
      messages: parse_messags(message_input)
    }
  end

  defp parse_rules(rule_input) do
    rule_input
    |> String.split("\n", trim: true)
    |> Enum.into(%{}, &parse_rule/1)
  end

  defp parse_rule(rule) do
    [label, values] = String.split(rule, ": ")
    {label, parse_values(values)}
  end

  defp parse_values(<<"\"", char::binary-size(1), "\"">>), do: char

  defp parse_values(values) do
    values
    |> String.split(" | ")
    |> case do
      [value] -> String.split(value, " ")
      values -> Enum.map(values, &String.split(&1, " "))
    end
  end

  defp parse_messags(message_input), do: String.split(message_input, "\n", trim: true)

  def build_pattern(rules), do: ~r/^#{pattern_for(rules, "0")}$/

  def pattern_for(rules, key) do
    case rules[key] do
      nil ->
        key

      value when is_binary(value) ->
        value

      values when is_list(hd(values)) ->
        "(?:#{
          values
          |> Enum.map(fn value ->
            Enum.map(value, &pattern_for(rules, &1))
          end)
          |> Enum.join("|")
        })"

      values ->
        values |> Enum.map(&pattern_for(rules, &1)) |> Enum.join()
    end
  end
end
