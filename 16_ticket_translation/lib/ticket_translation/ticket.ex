defmodule TicketTranslation.Ticket do
  def find_invalid_fields(ticket, rules) do
    ticket
    |> Tuple.to_list()
    |> Enum.reject(&valid_field?(&1, rules))
  end

  defp valid_field?(field, rules) do
    rules
    |> Map.values()
    |> List.flatten()
    |> Enum.any?(&(field in &1))
  end
end
