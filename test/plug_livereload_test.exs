defmodule PlugLivereloadTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import PlugLivereload

  @opts init([])
  @body """
  <head attribute=test></head>
  <body>
    <h1>This is a Test</h1>
  </body>
  """

  test "inserts livereload scripts in body" do
    headers = [{:headers, [{"content-type", "text/html"}] }]
    conn = conn("get", "/", @body, headers)
    |> call(@opts)

    assert String.contains?(conn.resp_body, "<head attribute=test>")
    assert String.contains?(conn.resp_body, "PLUG_LIVERELOAD_PORT = 3579;")
    assert String.contains?(conn.resp_body,
      "<script type=\"text/javascript\" src=\"#{livereload_source(conn)}\"></script>")
  end
end
