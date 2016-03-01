use Mix.Config

config :feederer,
  erlport: [
    python_path: to_char_list(Path.expand("priv")),
    compressed: 6,
    python: 'python'
  ],
  poolboy: [
    size: 10,
    max_overflow: 0
  ],
  supervisor_strategy: :one_for_one
