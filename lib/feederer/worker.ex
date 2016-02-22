defmodule Feederer.Worker do
  @moduledoc """
  Poolboy worker, dispatching parsing work to separate processes.
  """

  alias Feederer.Parser
  use GenServer

  def start_link([]) do
    :gen_server.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(%{feed: feed, opts: opts}, _from, state) do
    {:ok, parsed} = Parser.parse(feed, opts)
    {:reply, {:ok, parsed}, state}
  end

  def do_parse(pid, feed, opts) do
    args = %{feed: feed, opts: opts}
    :gen_server.call(pid, args)
  end
end
