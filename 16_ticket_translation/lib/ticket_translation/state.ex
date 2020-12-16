defmodule TicketTranslation.State do
  defstruct rules: %{}, raw_ticket: nil, ticket: nil, nearby_tickets: []

  def from_text(input) do
    [rules, ticket, tickets] = String.split(input, "\n\n")

    %__MODULE__{
      rules: parse_rules_block(rules),
      raw_ticket: parse_ticket_block(ticket),
      nearby_tickets: parse_tickets_block(tickets)
    }
  end

  defp parse_rules_block(rules_block) do
    rules_block
    |> String.split("\n")
    |> Enum.into(%{}, &parse_rule/1)
  end

  defp parse_rule(rule) do
    [label] = Regex.run(~r/^(.*):/, rule, capture: :all_but_first)
    ranges = ~r/(\d+)-(\d+)/
    |> Regex.scan(rule, capture: :all_but_first)
    |> Enum.map(&parse_range/1)
    {label, ranges}
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
    |> List.to_tuple()
  end
end
