defmodule ShowdownWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket,
    schema: ShowdownWeb.Schema

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
