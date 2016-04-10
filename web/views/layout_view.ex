defmodule CollaborativeCalendar.LayoutView do
  use CollaborativeCalendar.Web, :view

  def gen_token(conn, user) do
    Phoenix.Token.sign(conn, "token", user)
  end
end
