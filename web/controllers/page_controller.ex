defmodule Ouija.PageController do
  use Ouija.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
