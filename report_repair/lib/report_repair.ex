defmodule ReportRepair do
  def find_pair(input) do
    numbers = parse(input)

    numbers
    |> Enum.find_value(&find_pair(&1, numbers))
    |> Enum.reduce(&*/2)
  end

  def find_trio(input) do
    numbers = parse(input)

    numbers
    |> Enum.find_value(&find_trio(&1, numbers))
    |> Enum.reduce(&*/2)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp find_pair(value, numbers, total \\ 2020) do
    case Enum.find(numbers, &(&1 + value == total)) do
      nil -> nil
      number -> [value, number]
    end
  end

  defp find_trio(value, numbers) do
    case Enum.find_value(numbers, &find_pair(&1, numbers, 2020 - value)) do
      nil -> nil
      [a, b] -> [value, a, b]
    end
  end
end
