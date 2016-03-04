defmodule Feederer.Mixfile do
  use Mix.Project

  @version "0.5.3"

  def project do
    [app: :feederer,
     version: @version,
     elixir: "~> 1.0",
     deps: deps,
     source_url: "https://github.com/draftli/feederer",
     homepage_url: "https://github.com/draftli/feederer",
     docs: [
       source_ref: "v#{@version}",
       main: "readme",
       extras: ["README.md"]
     ],
     package: package]
  end

  def application do
    [
      applications: [:logger, :poolboy],
      env: [
        erlport: [
          python_path: to_char_list(Path.expand("priv")),
          compressed: 6,
          python: 'python'
        ],
        poolboy: [
          size: 10,
          max_overflow: 0
        ],
        supervisor_strategy: :one_for_one,
      ],
      mod: {Feederer, []},
    ]
  end

  defp deps do
    [{:erlport, git: "https://github.com/hdima/erlport.git",
      ref: "4041c0810f798cba9fa528ebca90556f0ae50645"},
     {:poolboy, "~> 1.5"},
     {:dialyxir, "~> 0.3", only: :dev},
     {:dogma, "~> 0.1", only: :dev},
     {:credo, "~> 0.3", only: [:dev, :test]},
     {:ex_doc, "~> 0.11", only: [:dev]},
     {:earmark, "~> 0.2", only: [:dev]}]
  end

  defp package do
    [maintainers: ["Victor Felder", "Martin Maillard", "Matthieu Maury"],
     licenses: ["LGPLv3"],
     description: "Parses XML syndication feeds such as RSS, Atom, etc. Elixir feedparser wrapper using erlport.",
     links: %{"GitHub" => "https://github.com/draftli/feederer"}]
  end
end
