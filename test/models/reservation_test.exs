defmodule CollaborativeCalendar.ReservationTest do
  use CollaborativeCalendar.ModelCase

  alias CollaborativeCalendar.Reservation

  @valid_attrs %{date: "2010-04-17", user: "asdf"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Reservation.changeset(%Reservation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Reservation.changeset(%Reservation{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "user required" do
    changeset = Reservation.changeset(%Reservation{}, %{date: "2016-04-11"})
    refute changeset.valid?
  end

  test "date required" do
    changeset = Reservation.changeset(%Reservation{}, %{user: "asdf"})
    refute changeset.valid?
  end

  test "date uniqueness" do
    changeset = Reservation.changeset(
      %Reservation{},
      %{date: "2016-04-11", user: "asdf"})
    changeset |> CollaborativeCalendar.Repo.insert
    reservation = changeset |> CollaborativeCalendar.Repo.insert

    assert {:error, invalidChangeset} = reservation
    assert invalidChangeset.errors[:date] == "has already been taken"
  end
end
