defmodule Ouija.CircleCITest do
  use ExSpec
  alias Ouija.CircleCI

  describe "builds/2" do
    it "queries the builds API!" do
      http_exec = fn req ->
        assert req.url |> String.starts_with?(
          "https://circleci.com/api/v1/project/lpil/ouija?circle-token="
        )
        assert req.body == ""
        assert req.headers == [{"Accept", "application/json"}]
        assert req.options == []
        res = %{
          status_code: 200,
          body: """
          [
            {
              "status":"ok",
              "committer_email":"louis@lpil.uk",
              "username":"lpil",
              "reponame":"ouija",
              "branch":"master"
            }
          ]
          """,
        }
        {:ok, res}
      end
      builds = CircleCI.builds "lpil", "ouija", http_exec
      assert builds == [
        %CircleCI.Build{
          status:  "ok",
          author:  "louis@lpil.uk",
          user:    "lpil",
          project: "ouija",
          branch:  "master"
        }
      ]
    end
  end
end
