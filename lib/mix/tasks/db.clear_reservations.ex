defmodule Mix.Tasks.Db.ClearReservations do
  use Mix.Task

  @shortdoc "Truncate reservations table and notify connected users"

  def run(_args) do
    CollaborativeCalendar.Repo.start_link

    Ecto.Adapters.SQL.query(
      CollaborativeCalendar.Repo,
      "TRUNCATE TABLE reservations;",
      [])
  end
end
