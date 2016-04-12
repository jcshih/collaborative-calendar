defmodule CollaborativeCalendar.Cron do
  use GenServer

  @interval 60 * 60 * 1000

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, @interval)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Ecto.Adapters.SQL.query(
      CollaborativeCalendar.Repo,
      "TRUNCATE TABLE reservations;",
      [])

    CollaborativeCalendar.Endpoint.broadcast(
      "reservations:booker",
      "all_reservations",
      %{user: [], other: []})

    Process.send_after(self(), :work, @interval)

    {:noreply, state}
  end
end
