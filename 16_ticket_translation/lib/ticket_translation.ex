defmodule TicketTranslation do
  @moduledoc """
  https://adventofcode.com/2020/day/16
  """

  @doc ~S'''
      iex> input = """
      ...> class: 1-3 or 5-7
      ...> row: 6-11 or 33-44
      ...> seat: 13-40 or 45-50
      ...> 
      ...> your ticket:
      ...> 7,1,14
      ...> 
      ...> nearby tickets:
      ...> 7,3,47
      ...> 40,4,50
      ...> 55,2,20
      ...> 38,6,12
      ...> """
      ...> TicketTranslation.error_rate(input)
      71
  '''
  def error_rate(input) do
    input
    |> parse()
    |> find_invalid_fields()
    |> Enum.sum()
  end

  defp parse(input) do
    [rules, ticket, tickets] = String.split(input, "\n\n")

    %{
      rules: parse_rules_block(rules),
      ticket: parse_ticket_block(ticket),
      nearby_tickets: parse_tickets_block(tickets)
    }
  end

  defp parse_rules_block(rules_block) do
    rules_block
    |> String.split("\n")
    |> Enum.map(&parse_rule/1)
  end

  defp parse_rule(rule) do
    ~r/(\d+)-(\d+)/
    |> Regex.scan(rule, capture: :all_but_first)
    |> Enum.map(&parse_range/1)
  end

  defp parse_range([from, to]) do
    String.to_integer(from)..String.to_integer(to)
  end

  defp parse_ticket_block(ticket_block) do
    ticket_block
    |> String.split("\n")
    |> Enum.drop(1)
    |> List.first()
    |> parse_ticket()
  end

  defp parse_tickets_block(tickets_block) do
    tickets_block
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(&parse_ticket/1)
  end

  defp parse_ticket(ticket_line) do
    ticket_line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp find_invalid_fields(%{rules: rules, nearby_tickets: tickets}) do
    Enum.flat_map(tickets, &find_invalid_ticket_fields(&1, rules))
  end

  defp find_invalid_ticket_fields(ticket, rules) do
    Enum.reject(ticket, &valid_field?(&1, rules))
  end

  defp valid_field?(field, rules) do
    rules
    |> List.flatten()
    |> Enum.any?(&(field in &1))
  end
end
