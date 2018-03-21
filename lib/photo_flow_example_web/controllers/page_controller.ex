defmodule PhotoFlowExampleWeb.PageController do
  use PhotoFlowExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
