defmodule Mix.Tasks.Feedparser.Install do
  @moduledoc """
  Install erlport and feedparser python dependencies.
  ## Example
      mix feederer.install
  """
  use Mix.Task

  def run(_args) do
    cwd = System.cwd
    local = cwd <> "/priv/"
    deps = cwd <> "/deps/feederer/priv/"
    file = "install.sh"
    cond do
      File.exists?(local <> file) ->
        System.cmd "sh", [file], [{:cd, local}]
      File.exists?(deps <> file) ->
        System.cmd "sh", [file], [{:cd, deps}]
      true ->
        Mix.raise "Could not find install script in #{deps} and #{local}."
    end
  end
end
