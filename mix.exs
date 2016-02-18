defmodule Feederer.Mixfile do
  use Mix.Project

  def project do
    [app: :feederer,
     version: "0.4.0",
     elixir: "~> 1.0",
     deps: deps,
     package: package]
  end

  def application do
    [
      mod: {Feederer, []},
      applications: [:logger, :poolboy]
    ]
  end

  defp deps do
    [{:erlport, git: "https://github.com/hdima/erlport.git",
      ref: "4041c0810f798cba9fa528ebca90556f0ae50645"},
     {:poolboy, "~> 1.5"},
     {:dogma, "~> 0.1", only: :dev},
     {:credo, "~> 0.3", only: [:dev, :test]}]
  end

  defp package do
    [contributors: ["Victor Felder", "Martin Maillard", "Matthieu Maury"],
     licenses: ["MIT"],
     description: "Elixir feedparser wrapper using erlport. Parses XML
syndication feeds such as RSS, Atom, etc.",
     links: %{"GitHub" => "https://github.com/vhf/feederer",
              "feedparser" => "https://github.com/kurtmckee/feedparser"}]
  end
end

defmodule Mix.Tasks.FeedparserInstall do
  use Mix.Task

  def run(_args) do
    System.cmd "sh", ["priv/install.sh"], [{:cd, System.cwd}]
  end
end
