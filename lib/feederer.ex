defmodule Feederer do
  use Application
  @moduledoc """
  Uses erlport to parse an XML syndication feed. Install feedparser and erlport
  with `mix FeedparserInstall`
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    opts = [strategy: :one_for_one, name: Feederer.Supervisor]
    Supervisor.start_link([], opts)
  end

  @doc """
  Parses a feed provided as a URL, a file path or a string.
  `etag` and `modified` parameters are documented on this page:
  https://pythonhosted.org/feedparser/http-etag.html

  Both etag and modified are optional. You can provide one, the other or both.
  """
  def parse(url_filepath_or_string, opts \\ []) do
    start_args = [
      {:python_path, to_char_list(Path.expand("priv"))},
      {:python, 'python'}]
    {:ok, pp} = :python.start(start_args)

    poll_args = [url_filepath_or_string, opts]
    :python.call(pp, :feedparserport, :parse, poll_args)
  end
end
