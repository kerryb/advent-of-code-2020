defmodule TicketTranslation.StateTest do
  use ExUnit.Case
  alias TicketTranslation.State
  doctest State

  describe "TicketTranslation.State.from_text/1" do
    test "converts the input into a struct" do
      input = """
      class: 1-3 or 5-7
      row: 6-11 or 33-44
      seat: 13-40 or 45-50

      your ticket:
      7,1,14

      nearby tickets:
      7,3,47
      40,4,50
      55,2,20
      38,6,12
      """
      assert State.from_text(input) == %State{
        rules: %{
          "class" => [1..3, 5..7],
          "row" => [6..11, 33..44],
          "seat" => [13..40, 45..50]
        },
        raw_ticket: {7, 1, 14},
        ticket: nil,
        nearby_tickets: [
          {7, 3, 47},
          {40,4,50},
          {55,2,20},
          {38,6,12}
        ]
      }
    end
  end
end
