defmodule Feederer do
  use Application
  @moduledoc """
  Uses erlport to parse an XML syndication feed. Install feedparser and erlport
  with `mix feedparser.install`
  """

  alias Feederer.Worker, as: Worker

  defp pool_name do
    :feederer_pool
  end

  def start(_type, opts) do
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, Worker},
      {:size, Keyword.get(opts, :pool_size, 10)},
      {:max_overflow, Keyword.get(opts, :max_overflow, 0)}
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    options = [
      strategy: :one_for_one,
      name: Feederer.Supervisor
    ]

    Supervisor.start_link(children, options)
  end

  def parse(url_filepath_or_string, opts \\ []) do
    dispatch_to_parser(url_filepath_or_string, opts)
  end

  defp dispatch_to_parser(url_filepath_or_string, opts) do
    :poolboy.transaction(
      pool_name(),
      fn(pid) -> Worker.do_parse(pid, url_filepath_or_string, opts) end,
      5 * 1000 # 5 seconds timeout for a worker
    )
  end
end
