defmodule OperationOrderTest do
  use ExUnit.Case
  doctest OperationOrder

  describe "OperationOrder.evaluate/1" do
    test "returns the sum of the evaluated expressions" do
      input = """
      2 * 3 + (4 * 5)
      5 + (8 * 3 + 9 + 3 * 4 * 3)
      """

      assert OperationOrder.evaluate(input) == 26 + 437
    end
  end

  describe "OperationOrder.evaluate_no_parens/1" do
    test "evaluates from left to right" do
      assert OperationOrder.evaluate_no_parens("1 + 2 * 3 + 4 * 5 + 6") == 71
    end
  end

  describe "OperationOrder.substitute/1" do
    test "replaces parenthesised sub-expressions with their results" do
      assert OperationOrder.substitute("1 + (2 * 3) * (3 + 4 * 5)") == "1 + 6 * 35"
    end

    test "handles nested parens" do
      assert OperationOrder.substitute("1 + (2 * (3 + 4))") == "1 + 14"
    end
  end
end
