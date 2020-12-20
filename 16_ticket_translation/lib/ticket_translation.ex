defmodule TicketTranslation do
  @moduledoc """
  https://adventofcode.com/2020/day/16
  """

  alias TicketTranslation.{State, Ticket}

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
    |> State.from_text()
    |> find_invalid_fields()
    |> Enum.sum()
  end

  def multiply_destination_fields(input) do
    input
    |> State.from_text()
    |> remove_invalid_tickets()
    |> State.identify_ticket_fields()
  end

  defp find_invalid_fields(%{rules: rules, nearby_tickets: tickets}) do
    Enum.flat_map(tickets, &Ticket.find_invalid_fields(&1, rules))
  end

  defp remove_invalid_tickets(%{rules: rules, nearby_tickets: tickets} = state) do
    put_in(state.nearby_tickets, Enum.filter(tickets, &Ticket.valid?(&1, rules)))
  end
end
