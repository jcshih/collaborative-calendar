defmodule CollaborativeCalendar.Helpers.Date do
  def date_from_js(date_js) do
    {:ok, date} = Map.update(date_js, "month", -1, &(&1 + 1)) |> Ecto.Date.cast
    date
  end
end
