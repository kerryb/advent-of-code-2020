defmodule TicketTranslation.TicketTest do
  use ExUnit.Case
  alias TicketTranslation.Ticket
  doctest Ticket

  describe "TicketTranslation.Ticket.find_invalid_fields/2" do
    test "returns any fields that don't match any rule" do
      ticket = {1, 5, 7, 3, 12, 48}
      rules = %{"foo" => [1..3, 6..8], "bar" => [10..15]}
      assert Ticket.find_invalid_fields(ticket, rules) == [5, 48]
    end
  end

  describe "TicketTranslation.Ticket.valid?/2" do
    test "returns true if all fields match at least one rule" do
      ticket = {1, 7, 12}
      rules = %{"foo" => [1..3, 6..8], "bar" => [10..15]}
      assert Ticket.valid?(ticket, rules)
    end

    test "returns false if any field doesn't match at least one rule" do
      ticket = {1, 7, 9, 12}
      rules = %{"foo" => [1..3, 6..8], "bar" => [10..15]}
      refute Ticket.valid?(ticket, rules)
    end
  end

  describe "TicketTranslation.Ticket.identify_fields/2" do
    test "returns the ordered field names, based on which rules they match" do
      tickets = [{3, 9, 18}, {15, 1, 5}, {5, 14, 9}]
      rules = %{"class" => [0..1, 4..19], "row" => [0..5, 8..19], "seat" => [0..13, 16..19]}
      assert Ticket.identify_fields(tickets, rules) == {"class", "row", "seat"}
    end
  end
end
