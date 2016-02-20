defmodule Mix.Tasks.Feedparser.Install do
  @moduledoc """
  Install erlport and feedparser python dependencies.
  ## Example
      mix feederer.install
  """
  use Mix.Task

  def run(_args) do
    System.cmd "sh", ["priv/install.sh"], [{:cd, System.cwd}]
  end
end
