defmodule CollaborativeCalendar.FakeCanceller do
  use GenServer

  alias CollaborativeCalendar.Repo
  alias CollaborativeCalendar.Reservation

  @interval 1 * 60 * 1000 + 31 * 1000

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, @interval)
    {:ok, state}
  end

  def handle_info(:work, state) do
    reservations = Reservation.user_reservations("fake") |> Repo.all

    if Enum.count(reservations) > 4 do
      reservation = Enum.random reservations

      case Repo.delete reservation do
        {:ok, r} ->
          CollaborativeCalendar.Endpoint.broadcast(
            "reservations:booker",
            "cancellation_updated",
            r)
        {:error, _changeset} ->
          :error
      end
    end

    Process.send_after(self(), :work, @interval)

    {:noreply, state}
  end
end
