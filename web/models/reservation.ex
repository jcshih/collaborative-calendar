defmodule CollaborativeCalendar.Reservation do
  use CollaborativeCalendar.Web, :model

  schema "reservations" do
    field :user, :string
    field :date, Ecto.Date

    timestamps
  end

  @required_fields ~w(user date)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
