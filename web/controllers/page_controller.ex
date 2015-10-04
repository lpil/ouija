defmodule Ouija.PageController do
  @moduledoc """
  Providing static HTML pages.
  """

  use Ouija.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
