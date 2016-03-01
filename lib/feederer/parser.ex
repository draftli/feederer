defmodule Feederer.Parser do
  @moduledoc """
  The actual Elixir <-> Python feedparser communication.
  """

  @doc """
  Parses a feed provided as a URL, a file path or a string.

  parse(feed, arg1: arg1, arg2: arg2, …)

  `feed` is the only mandatory argument. Other arguments can be the following:
  * etag
  * modified
  * agent
  * referrer
  * request_headers
  * response_headers

  Their usage is documented in feedparser documentation:
  https://pythonhosted.org/feedparser/
  """
  @spec parse(String.t, %{}) :: {:ok, String.t}
  def parse(feed, opts \\ %{}) do
    start_args = Application.fetch_env!(:feederer, :erlport)
    {:ok, pp} = :python.start(start_args)

    poll_args = [feed, opts]
    :python.call(pp, :feedparserport, :parse, poll_args)
  end
end
