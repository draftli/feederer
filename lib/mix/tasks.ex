defmodule Mix.Tasks.Feedparser.Install do
  @moduledoc """
  Install erlport and feedparser python dependencies.
  ## Example
      mix feederer.install
  """
  use Mix.Task

  def run(_args) do
    path = System.cwd <> "/priv/"
    file = "install.sh"
    cond do
      File.exists?(path <> file) ->
        System.cmd "sh", [file], [{:cd, path}]
      File.exists?(path <> "/deps/" <> file) ->
        System.cmd "sh", [file], [{:cd, path <> "/deps/"}]
      true ->
        Mix.raise "Could not find install script in #{path} and #{path}/deps/."
    end
  end
end
