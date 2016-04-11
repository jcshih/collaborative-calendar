defmodule CollaborativeCalendar.Repo.Migrations.AddIndexToReservations do
  use Ecto.Migration

  def change do
    create unique_index(:reservations, [:date])
  end
end
