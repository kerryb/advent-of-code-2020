defmodule TicketTranslation.TicketTest do
  use ExUnit.Case
  alias TicketTranslation.Ticket
  doctest Ticket

  describe "TicketTranslation.Ticket.find_invalid_fields/2" do
    test "returns any fields that don't match any rule" do
      rules = %{"foo" => [1..3, 6..8], "bar" => [10..15]}
      ticket = {1, 5, 7, 3, 12, 48}
      assert Ticket.find_invalid_fields(ticket, rules) == [5, 48]
    end
  end
end
