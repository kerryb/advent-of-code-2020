defmodule ShuttleSearch do
  @moduledoc """
  https://adventofcode.com/2020/day/13
  """

  defstruct [:earliest_time, :in_service, :earliest_bus, :minutes_remaining]

  @doc ~S'''
      iex> input = """
      ...> 939
      ...> 7,13,x,x,59,x,31,19
      ...> """
      ...> ShuttleSearch.earliest_bus(input)
      295
  '''
  def earliest_bus(input) do
    input
    |> parse()
    |> find_earliest()
    |> multiply_id_and_wait()
  end

  defp parse(input) do
    [earliest_time, bus_list] = String.split(input, "\n", trim: true)

    in_service =
      bus_list
      |> String.split(",")
      |> Enum.reject(&(&1 == "x"))
      |> Enum.map(&String.to_integer/1)

    %__MODULE__{earliest_time: String.to_integer(earliest_time), in_service: in_service}
  end

  defp find_earliest(state) do
    bus = Enum.min_by(state.in_service, &minutes_remaining(state.earliest_time, &1))
    %{state | earliest_bus: bus, minutes_remaining: minutes_remaining(state.earliest_time, bus)}
  end

  defp minutes_remaining(time, bus_id) do
    bus_id - Integer.mod(time, bus_id)
  end

  defp multiply_id_and_wait(state) do
    state.earliest_bus * state.minutes_remaining
  end
end
