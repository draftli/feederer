defmodule Feederer.Parser do
  @moduledoc """
  The actual Elixir <-> Python feedparser communication.
  """

  @doc """
  Parses a feed provided as a URL, a file path or a string.
  `etag` and `modified` parameters are documented on this page:
  https://pythonhosted.org/feedparser/http-etag.html

  Both etag and modified are optional. You can provide one, the other or both.
  """
  @spec parse(String.t, %{}) :: {:ok, String.t}
  def parse(feed, opts \\ %{}) do
    start_args = [
      {:python_path, to_char_list(Path.expand("priv"))},
      {:python, 'python'}]
    {:ok, pp} = :python.start(start_args)

    poll_args = [feed, opts]
    :python.call(pp, :feedparserport, :parse, poll_args)
  end
end
