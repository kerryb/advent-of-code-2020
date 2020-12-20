defmodule TicketTranslation.Ticket do
  def find_invalid_fields(ticket, rules) do
    ticket
    |> Tuple.to_list()
    |> Enum.reject(&valid_field?(&1, rules))
  end

  def valid?(ticket, rules) do
    ticket
    |> Tuple.to_list()
    |> Enum.all?(&valid_field?(&1, rules))
  end

  defp valid_field?(field, rules) do
    rules
    |> Map.values()
    |> List.flatten()
    |> Enum.any?(&(field in &1))
  end

  def identify_fields(tickets, rules) do
    0..(tuple_size(hd(tickets)) - 1)
    |> Enum.map(&possible_labels(&1, tickets, rules))
    |> find_valid_combination()
  end

  defp possible_labels(index, tickets, rules) do
    fields = Enum.map(tickets, &elem(&1, index))

    possible_labels =
      rules
      |> Enum.filter(&all_valid?(fields, &1))
      |> Enum.map(&elem(&1, 0))

    {:possible_labels, possible_labels}
  end

  defp find_valid_combination(labels) do

  end

  defp all_valid?(fields, {label, ranges}) do
    Enum.all?(fields, &valid_field?(&1, %{label => ranges}))
  end
end
