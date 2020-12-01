defmodule ReportRepair do
  def find(input) do
    numbers =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    numbers
    |> Enum.find_value(&find_pair(&1, numbers))
    |> Enum.reduce(&*/2)
  end

  defp find_pair(value, numbers) do
    case Enum.find(numbers, &(&1 + value == 2020)) do
      nil -> nil
      number -> [value, number]
    end
  end
end
