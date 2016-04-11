defmodule CollaborativeCalendar.ReservationChannel do
  use CollaborativeCalendar.Web, :channel

  alias CollaborativeCalendar.Reservation

  def join("reservations:booker", payload, socket) do
    send self, :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    user = socket.assigns.user
    userReservations = Reservation.user_reservations(user) |> Repo.all
    otherReservations = Reservation.other_reservations(user) |> Repo.all

    push socket, "all_reservations", %{
      user: userReservations,
      other: otherReservations
    }

    {:noreply, socket}
  end
end
