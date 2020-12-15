defmodule RambunctiousRecitation do
  @moduledoc """
  https://adventofcode.com/2020/day/15
  """

  defstruct turn: 0, last_seen: %{}, last_play: nil

  @doc """
      iex> RambunctiousRecitation.play("0,3,6", 2020)
      436
  """
  def play(input, turns) do
    input
    |> parse()
    |> play_turns(turns)
    |> Map.get(:last_play)
  end

  defp parse(input), do: input |> String.split(",") |> Enum.map(&String.to_integer/1)

  defp play_turns(starter, turns) do
    state = Enum.reduce(starter, %__MODULE__{}, &play_starter_turn/2)
    Enum.reduce((length(starter) + 1)..turns, state, &play_turn/2)
  end

  defp play_starter_turn(number, state), do: update_state(state, number)

  defp play_turn(_turn, state) do
    case state.last_seen[state.last_play] do
      nil -> update_state(state, 0)
      seen -> update_state(state, state.turn - seen)
    end
  end

  defp update_state(state, play) do
    %{
      state
      | last_seen: Map.put(state.last_seen, state.last_play, state.turn),
        last_play: play,
        turn: state.turn + 1
    }
  end
end
