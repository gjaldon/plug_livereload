defmodule PlugLivereload do
  alias Plug.Conn

  @livereload_path Path.expand("js/livereload.js")
  @livereload_port 3579

  def init([]) do
  end

  def call(conn, _) do
    insert_script(conn)
  end

  def insert_script(conn) do
    {:ok, body, conn} = Conn.read_body(conn)
    new_body = String.replace(body, ~r/(<head>|<head[^(er)][^<]*>)/, "\\1\n#{template(conn)}", global: false)
    Conn.resp(conn, 200, new_body)
  end

  def template(conn) do
    EEx.eval_file "template/livereload.html.eex", [
      livereload_source: livereload_source(conn),
      livereload_port: @livereload_port
    ]
  end

  def livereload_source(conn) do
    "#{@livereload_path}?host=#{conn.host}"
  end
end
