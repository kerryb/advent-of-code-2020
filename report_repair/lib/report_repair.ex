defmodule ReportRepair do
  def find(input) do
    numbers =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    Enum.find_value(numbers, &find_and_multiply_pair(&1, numbers))
  end

  defp find_and_multiply_pair(value, numbers) do
    case Enum.find(numbers, &(&1 + value == 2020)) do
      nil -> nil
      number -> value * number
    end
  end
end
