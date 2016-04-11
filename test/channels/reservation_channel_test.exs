defmodule CollaborativeCalendar.ReservationChannelTest do
  use CollaborativeCalendar.ChannelCase

  alias CollaborativeCalendar.ReservationChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(ReservationChannel, "reservations:booker")

    {:ok, socket: socket}
  end
end
