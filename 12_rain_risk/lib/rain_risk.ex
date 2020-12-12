defmodule RainRisk do
  @moduledoc """
  https://adventofcode.com/2020/day/12
  """

  @doc ~S'''
      iex> input = """
      ...> F10
      ...> N3
      ...> F7
      ...> R90
      ...> F11
      ...> """
      ...> RainRisk.navigate(input)
      25
  '''
  def navigate(input) do
    input
    |> parse()
    |> follow()
    |> manhattan_distance()
  end

  @doc ~S'''
      iex> input = """
      ...> F10
      ...> N3
      ...> F7
      ...> R90
      ...> F11
      ...> """
      ...> RainRisk.navigate_by_waypoint(input)
      286
  '''
  def navigate_by_waypoint(input) do
    input
    |> parse()
    |> follow_waypoint()
    |> manhattan_distance()
  end

  defp parse(input) do
    ~r/^(.)(\d+)/m
    |> Regex.scan(input, capture: :all_but_first)
    |> Enum.map(fn [action, value] -> {action, String.to_integer(value)} end)
  end

  defp follow(instructions), do: Enum.reduce(instructions, {0, 0, "E"}, &move/2)

  defp move({"F", value}, {x, y, "N"}), do: {x, y + value, "N"}
  defp move({"F", value}, {x, y, "E"}), do: {x + value, y, "E"}
  defp move({"F", value}, {x, y, "S"}), do: {x, y - value, "S"}
  defp move({"F", value}, {x, y, "W"}), do: {x - value, y, "W"}

  defp move({"N", value}, {x, y, heading}), do: {x, y + value, heading}
  defp move({"E", value}, {x, y, heading}), do: {x + value, y, heading}
  defp move({"S", value}, {x, y, heading}), do: {x, y - value, heading}
  defp move({"W", value}, {x, y, heading}), do: {x - value, y, heading}

  defp move({"R", 90}, {x, y, "N"}), do: {x, y, "E"}
  defp move({"R", 90}, {x, y, "E"}), do: {x, y, "S"}
  defp move({"R", 90}, {x, y, "S"}), do: {x, y, "W"}
  defp move({"R", 90}, {x, y, "W"}), do: {x, y, "N"}

  defp move({"R", 180}, {x, y, "N"}), do: {x, y, "S"}
  defp move({"R", 180}, {x, y, "E"}), do: {x, y, "W"}
  defp move({"R", 180}, {x, y, "S"}), do: {x, y, "N"}
  defp move({"R", 180}, {x, y, "W"}), do: {x, y, "E"}

  defp move({"R", 270}, {x, y, "N"}), do: {x, y, "W"}
  defp move({"R", 270}, {x, y, "E"}), do: {x, y, "N"}
  defp move({"R", 270}, {x, y, "S"}), do: {x, y, "E"}
  defp move({"R", 270}, {x, y, "W"}), do: {x, y, "S"}

  defp move({"L", value}, state), do: move({"R", 360 - value}, state)

  defp follow_waypoint(instructions) do
    Enum.reduce(instructions, {{0, 0}, {10, 1}}, &move_by_waypoint/2)
  end

  defp move_by_waypoint({"F", value}, {{x, y}, {wx, wy}}) do
    {{x + wx * value, y + wy * value}, {wx, wy}}
  end

  defp move_by_waypoint({"N", value}, {{x, y}, {wx, wy}}), do: {{x, y}, {wx, wy + value}}
  defp move_by_waypoint({"E", value}, {{x, y}, {wx, wy}}), do: {{x, y}, {wx + value, wy}}
  defp move_by_waypoint({"S", value}, {{x, y}, {wx, wy}}), do: {{x, y}, {wx, wy - value}}
  defp move_by_waypoint({"W", value}, {{x, y}, {wx, wy}}), do: {{x, y}, {wx - value, wy}}

  defp move_by_waypoint({"R", 90}, {{x, y}, {wx, wy}}), do: {{x, y}, {wy, -wx}}
  defp move_by_waypoint({"R", 180}, {{x, y}, {wx, wy}}), do: {{x, y}, {-wx, -wy}}
  defp move_by_waypoint({"R", 270}, {{x, y}, {wx, wy}}), do: {{x, y}, {-wy, wx}}

  defp move_by_waypoint({"L", value}, state), do: move_by_waypoint({"R", 360 - value}, state)

  defp manhattan_distance({x, y, _}), do: abs(x) + abs(y)
  defp manhattan_distance({{x, y}, _}), do: abs(x) + abs(y)
end
