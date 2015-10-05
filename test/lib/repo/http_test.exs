defmodule Ouija.Repo.HTTPTest do
  use ExSpec, async: false # We're mocking :(

  alias Ouija.Repo.HTTP

  it "calls through to HTTPoison" do
    request = %HTTP{
      method: :patch,
      url: "https://github.com/lpil/ouija",
      body: ~s({"foo":"bar"}),
      headers: [{"Accept", "application/json"}],
      options: [timeout: 500],
    }
    :meck.new(HTTPoison, [:request])
    :meck.expect(HTTPoison, :request, fn method, url, body, headers, opts ->
      assert method  == request.method
      assert url     == request.url
      assert body    == request.body
      assert headers == request.headers
      assert opts    == request.options
      :http_response
    end)
    result = HTTP.exec( request )
    assert :http_response == result
    :meck.validate( HTTPoison )
    :meck.unload( HTTPoison )
  end
end
