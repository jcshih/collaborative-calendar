defmodule CollaborativeCalendar.ReservationTest do
  use CollaborativeCalendar.ModelCase

  alias CollaborativeCalendar.Reservation

  @valid_attrs %{date: "2010-04-17", user: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Reservation.changeset(%Reservation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Reservation.changeset(%Reservation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
