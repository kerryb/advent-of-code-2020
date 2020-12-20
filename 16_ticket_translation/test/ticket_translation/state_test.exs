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
                 {40, 4, 50},
                 {55, 2, 20},
                 {38, 6, 12}
               ]
             }
    end
  end

  describe "TicketTranslation.State.identify_ticket_fields/1" do
    test "populates ticket with a map of field names to values" do
      state =
        State.identify_ticket_fields(%State{
          nearby_tickets: [{3, 9, 18}, {15, 1, 5}, {5, 14, 9}],
          raw_ticket: {11, 12, 13},
          rules: %{
            "class" => [0..1, 4..19],
            "row" => [0..5, 8..19],
            "seat" => [0..13, 16..19]
          },
          ticket: nil
        })

      assert state.ticket == %{"row" => 11, "class" => 12, "seat" => 13}
    end
  end
end
