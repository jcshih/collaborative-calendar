defmodule CollaborativeCalendar.Repo.Migrations.CreateReservation do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :user, :string
      add :date, :date

      timestamps
    end

  end
end
