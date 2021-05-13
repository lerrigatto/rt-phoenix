defmodule CiaoSocketsWeb.StatsSocket do
  use Phoenix.Socket

  channel "*", CiaoSocketsWeb.StatsChannel

  def connect(_params, socket, _connect_info) do
    CiaoSockets.Statix.increment("socket_connect", 1, tags: ["status:success", "socket:StatsSocket"])
    {:ok, socket}
  end

  def id(_socket), do: nil
end
