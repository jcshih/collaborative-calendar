defmodule CollaborativeCalendar.PageController do
  use CollaborativeCalendar.Web, :controller

  plug :authenticate

  def index(conn, _params) do
    render conn, "index.html", user: get_session(conn, :user)
  end

  defp authenticate(conn, _opts) do
    unless get_session(conn, :user) do
      conn = put_session(conn, :user,
                         :crypto.strong_rand_bytes(8) |> Base.encode64)
    end
    conn
  end
end
