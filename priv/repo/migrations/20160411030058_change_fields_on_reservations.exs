defmodule CollaborativeCalendar.Repo.Migrations.ChangeFieldsOnReservations do
  use Ecto.Migration

  def change do
    alter table(:reservations) do
      modify :user, :string, null: false
      modify :date, :date, null: false
    end
  end
end
