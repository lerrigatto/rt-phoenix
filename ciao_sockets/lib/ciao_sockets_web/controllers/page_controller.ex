defmodule CiaoSocketsWeb.PageController do
  use CiaoSocketsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
