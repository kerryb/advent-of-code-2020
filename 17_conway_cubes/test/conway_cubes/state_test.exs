defmodule ConwayCubes.StateTest do
  use ExUnit.Case, async: true

  alias ConwayCubes.State
  doctest State

  describe "ConwayCubes.State.from_text/1" do
    test "populates a struct" do
      text = """
      .#.
      ..#
      ###
      """

      assert State.from_text(text) == %State{
               x: 0..2,
               y: 0..2,
               z: 0..0,
               active: MapSet.new([{1, 0, 0}, {2, 1, 0}, {0, 2, 0}, {1, 2, 0}, {2, 2, 0}])
             }
    end
  end

  describe "ConwayCubes.State.advance/1" do
    test "moves the state on a generation" do
      state = %State{
        x: 0..2,
        y: 0..2,
        z: 0..0,
        active: MapSet.new([{1, 0, 0}, {2, 1, 0}, {0, 2, 0}, {1, 2, 0}, {2, 2, 0}])
      }

      assert State.advance(state) == %State{
               x: -1..3,
               y: -1..3,
               z: -1..1,
               active:
                 MapSet.new([
                   {0, 1, -1},
                   {2, 2, -1},
                   {1, 3, -1},
                   {0, 1, 0},
                   {2, 1, 0},
                   {1, 2, 0},
                   {2, 2, 0},
                   {1, 3, 0},
                   {0, 1, 1},
                   {2, 2, 1},
                   {1, 3, 1}
                 ])
             }
    end
  end

  describe "ConwayCubes.State.neigbours/1" do
    test "returns 26 locations" do
      assert length(State.neigbours({1, 2, 3})) == 26
    end

    test "does not return the original location" do
      refute {1, 2, 3} in State.neigbours({1, 2, 3})
    end

    test "returns unique locations" do
      neighbours = State.neigbours({1, 2, 3})
      assert length(neighbours) == length(Enum.sort(neighbours))
    end

    test "returns locations 0 or 1 in any direction" do
      assert Enum.all?(State.neigbours({1, 2, 3}), fn {x, y, z} ->
               x in 0..2 and y in 1..3 and z in 2..4
             end)
    end
  end
end
