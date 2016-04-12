defmodule CollaborativeCalendar.UserSocket do
  use Phoenix.Socket

  channel "reservations:booker", CollaborativeCalendar.ReservationChannel

  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000

  def connect(%{ "token" => token }, socket) do
    case Phoenix.Token.verify(socket, "token", token) do
      { :ok, user } ->
        { :ok, assign(socket, :user, user) }
      { :error, _ } ->
        :error
    end
  end

  def connect(_params, socket) do
    :error
  end

  def id(_socket), do: nil
end
