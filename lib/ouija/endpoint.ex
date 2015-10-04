defmodule Ouija.Endpoint do
  @moduledoc """
  HTTP entrypoint
  """

  use Phoenix.Endpoint, otp_app: :ouija

  socket "/socket", Ouija.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :ouija, gzip: false,
    only: ~w(css fonts images js favicon.ico humans.txt robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_ouija_key",
    signing_salt: "IOzoPOIq"

  plug Ouija.Router
end
