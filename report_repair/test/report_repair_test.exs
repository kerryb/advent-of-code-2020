defmodule ReportRepairTest do
  use ExUnit.Case
  doctest ReportRepair

  test "finds and multiplies the two numbers which total 2020" do
    input = """
            1721
            979
            366
            299
            675
            1456
            """

    assert ReportRepair.find(input) == 514_579
  end
end
