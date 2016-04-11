defmodule CollaborativeCalendar.ReservationChannel do
  use CollaborativeCalendar.Web, :channel

  alias CollaborativeCalendar.Reservation

  intercept ["reservation_updated", "cancellation_updated"]

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

  def handle_in("make_reservation", payload, socket) do
    user = socket.assigns.user
    { :ok, date } = Ecto.Date.cast payload

    case Repo.insert(%Reservation{user: user, date: date}) do
      {:ok, r} ->
        broadcast socket, "reservation_updated", r
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, "Failed to make reservation"}, socket}
    end
  end

  def handle_out("reservation_updated", reservation, socket) do
    if socket.assigns.user == reservation.user do
      push socket, "user_reservation_update", reservation
    else
      push socket, "other_reservation_update", reservation
    end

    {:noreply, socket}
  end

  def handle_in("cancel_reservation", payload, socket) do
    user = socket.assigns.user
    { :ok, date } = Ecto.Date.cast payload

    [reservation] = Reservation.find_by_date(date) |> Repo.all
    case Repo.delete(reservation) do
      {:ok, _model} ->
        broadcast socket, "cancellation_updated", reservation
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, "Failed to cancel reservation"}, socket}
    end
  end

  def handle_out("cancellation_updated", reservation, socket) do
    if socket.assigns.user == reservation.user do
      push socket, "user_cancellation_update", reservation
    else
      push socket, "other_cancellation_update", reservation
    end

    {:noreply, socket}
  end
end
