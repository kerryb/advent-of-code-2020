defmodule ConwayCubesTest do
  use ExUnit.Case
  doctest ConwayCubes

  describe "ConwayCubes.run/1" do
    test "returns the number of active cubes after six cycles" do
      input = """
      .#.
      ..#
      ###
      """
    assert ConwayCubes.run(input) == 112
  end
end
end
