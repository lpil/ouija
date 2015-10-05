defmodule Ouija.CircleCI do
  @moduledoc """
  CircleCI is a neato third party platform that will run your tests for you.
  We're interested in using its API to find out how our builds are doing.
  """

  defmodule Build do
    @moduledoc "Represents a CI build"
    defstruct status:  nil,
              branch:  nil,
              user:    nil,
              project: nil,
              author:  nil
  end

  alias Ouija.Repo.HTTP

  @http_exec &HTTP.exec/1
  @baseurl "https://circleci.com/api/v1"
  @headers [{"Accept", "application/json"}]

  @spec builds(String.t, String.t, HTTP.t) :: [%Build{}]
  @doc """
  Fetches the latest builds for given CircleCI project from the CircleCI API
  via HTTP.
  """
  def builds(user, project, http_exec \\ @http_exec) do
    url = builds_url( user, project )
    req = %HTTP{ method: :get, url: url, headers: @headers }
    {:ok, res} = req |> http_exec.()
    200 = res.status_code # Should always recieve 200
    res.body |> Poison.decode! |> Enum.map(&raw_to_struct/1)
  end


  defp raw_to_struct(data) do
    %Build{
      status:  data["status"],
      branch:  data["branch"],
      user:    data["username"],
      project: data["reponame"],
      author:  data["committer_email"],
    }
  end

  defp builds_url(user, project) do
    token = Application.get_env :ouija, :circle_ci_auth_token
    "#{@baseurl}/project/#{user}/#{project}?circle-token=#{token}"
  end
end
