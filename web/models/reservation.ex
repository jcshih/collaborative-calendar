defmodule CollaborativeCalendar.Reservation do
  use CollaborativeCalendar.Web, :model

  alias CollaborativeCalendar.Reservation

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
    |> unique_constraint(:date)
  end

  def user_reservations(user) do
    from r in Reservation, where: r.user == ^user
  end

  def other_reservations(user) do
    from r in Reservation, where: r.user != ^user
  end

  def find_by_date(date) do
    from r in Reservation, where: r.date == ^date
  end
end

defimpl Poison.Encoder, for: CollaborativeCalendar.Reservation do
  def encode(model, opts) do
    {:ok, { year, month, day }} = Ecto.Date.dump model.date
    %{year: year,
      month: month,
      day: day
     } |> Poison.Encoder.encode(opts)
  end
end
