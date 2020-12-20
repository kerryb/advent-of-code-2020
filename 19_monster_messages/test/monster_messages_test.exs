defmodule MonsterMessagesTest do
  use ExUnit.Case
  doctest MonsterMessages

  describe "MonsterMessages.parse/1" do
    test "returns rules and messages" do
      input = """
      0: 4 1 5
      1: 2 3 | 3 2
      4: "a"

      ababbb
      bababa
      """

      assert MonsterMessages.parse(input) == %{
               rules: %{
                 "0" => ["4", "1", "5"],
                 "1" => [["2", "3"], ["3", "2"]],
                 "4" => "a"
               },
               messages: [
                 "ababbb",
                 "bababa"
               ]
             }
    end
  end

  describe "MonsterMessages.build_pattern" do
    test "recursively converts rule 0 to a pattern" do
      rules = %{
        "0" => ["4", "1", "5"],
        "1" => [["2", "3"], ["3", "2"]],
        "2" => [["4", "4"], ["5", "5"]],
        "3" => [["4", "5"], ["5", "4"]],
        "4" => "a",
        "5" => "b"
      }

      assert MonsterMessages.build_pattern(rules) == ~r/^a(?:(?:aa|bb)(?:ab|ba)|(?:ab|ba)(?:aa|bb))b$/
    end
  end

  describe "MonsterMessages.pattern_for/2" do
    test "returns just the character for a literal character" do
      assert MonsterMessages.pattern_for(%{"1" => "a"}, "1") == "a"
    end

    test "concatenates references to literal characters" do
      assert MonsterMessages.pattern_for(%{"1" => ["2", "3"], "2" => "a", "3" => "b"}, "1") ==
               "ab"
    end

    test "builds groups for choices of parameters" do
      assert MonsterMessages.pattern_for(
               %{"1" => [["2", "3"], ["3", "2"]], "2" => "a", "3" => "b"},
               "1"
             ) ==
               "(?:ab|ba)"
    end
  end
end
