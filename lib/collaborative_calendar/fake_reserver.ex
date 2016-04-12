defmodule CollaborativeCalendar.FakeReserver do
  use GenServer

  alias CollaborativeCalendar.Repo
  alias CollaborativeCalendar.Reservation

  @interval 60 * 1000

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, @interval)
    {:ok, state}
  end

  def handle_info(:work, state) do
    case Repo.insert(%Reservation{user: "fake", date: random_date}) do
      {:ok, r} ->
        CollaborativeCalendar.Endpoint.broadcast(
          "reservations:booker",
          "reservation_updated",
          r)
      {:error, _changeset} ->
        :error
    end

    Process.send_after(self(), :work, @interval)

    {:noreply, state}
  end

  def random_date() do
    {current_date, _} = :calendar.local_time
    days = :calendar.date_to_gregorian_days(current_date) + :rand.uniform(120) - 60
    {year, month, day} = :calendar.gregorian_days_to_date days
    %{year: year, month: month, day: day} |> Ecto.Date.cast!
  end
end
