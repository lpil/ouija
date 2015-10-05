defmodule Ouija.Repo.HTTP do
  @moduledoc """
  An abstraction around exernal resources accessed via HTTP.
  """

  defstruct method:  :get,
            url:     nil,
            body:    nil,
            headers: [],
            options: []

  @type http_request  :: %__MODULE__{}
  @type http_response :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
  @type http_error    :: HTTPoison.Error.t

  @spec exec(http_request) :: {:ok, http_response} | {:error, http_error}
  @doc """
  Perform a HTTP request.

  iex> %Ouija.Repo.HTTP{ method: :get, url: "https://github.com/lpil" }
  .... |> Ouija.Repo.HTTP.exec
  """
  def exec(%__MODULE__{} = request) do
    HTTPoison.request(
      request.method,
      request.url,
      request.body,
      request.headers,
      request.options
    )
  end
end
