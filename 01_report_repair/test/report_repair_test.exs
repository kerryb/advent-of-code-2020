defmodule ReportRepairTest do
  use ExUnit.Case
  doctest ReportRepair

  describe "ReportRepair.find_pair/1" do
    test "finds and multiplies the two numbers which total 2020" do
      input = """
      1721
      979
      366
      299
      675
      1456
      """

      assert ReportRepair.find_pair(input) == 514_579
    end
  end

  describe "ReportRepair.find_trio/1" do
    test "finds and multiplies the three numbers which total 2020" do
      input = """
      1721
      979
      366
      299
      675
      1456
      """

      assert ReportRepair.find_trio(input) == 241_861_950
    end
  end
end
