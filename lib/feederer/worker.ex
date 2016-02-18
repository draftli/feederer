defmodule Feederer.Worker do
  @moduledoc """
  Poolboy worker, dispatching parsing work to separate processes.
  """

  import Feederer.Parser
  use GenServer

  def start_link([]) do
    :gen_server.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(args, _from, state) do
    url_filepath_or_string = args[:url_filepath_or_string]
    opts = args[:opts]
    {:ok, parsed} = parse(url_filepath_or_string, opts)
    {:reply, {:ok, parsed}, state}
  end

  def do_parse(pid, url_filepath_or_string, opts) do
    args = [url_filepath_or_string: url_filepath_or_string, opts: opts]
    :gen_server.call(pid, args)
  end
end
