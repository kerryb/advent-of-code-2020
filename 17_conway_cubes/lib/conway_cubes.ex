defmodule ConwayCubes do
  @moduledoc """
  https://adventofcode.com/2020/day/17
  """

  alias ConwayCubes.State

  def run(input) do
    1..6
    |> Enum.reduce(State.from_text(input), fn _, state -> State.advance(state) end)
    |> Map.fetch!(:active)
    |> MapSet.size()
  end
end
