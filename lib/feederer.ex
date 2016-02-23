defmodule Feederer do
  use Application
  @moduledoc """
  Uses erlport to parse an XML syndication feed.
  """

  alias Feederer.Worker

  defp pool_name do
    :feederer_pool
  end

  def start(_type, _opts) do
    local_config = [name: {:local, pool_name()}, worker_module: Worker]
    mix_config = Application.fetch_env!(:feederer, :poolboy)
    poolboy_config = mix_config |> Keyword.merge(local_config)

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    options = [
      strategy: Application.fetch_env!(:feederer, :supervisor_strategy),
      name: Feederer.Supervisor
    ]

    Supervisor.start_link(children, options)
  end

  def parse(feed, opts \\ []) do
    dispatch_to_parser(feed, opts)
  end

  defp dispatch_to_parser(feed, opts) do
    :poolboy.transaction(
      pool_name(),
      fn(pid) -> Worker.do_parse(pid, feed, opts) end,
      5 * 1000 # 5 seconds timeout for a worker
    )
  end
end
