defmodule CollaborativeCalendar.PageController do
  use CollaborativeCalendar.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
