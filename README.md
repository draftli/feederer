# Feederer

Feederer can fetch more than 17 Major singles titles from your RSS / Atom feeds.

Feederer is an Elixir wrapper for
[feedparser](https://github.com/kurtmckee/feedparser).

It parses XML syndication feeds such as [RSS 0.90, Netscape RSS 0.91, Userland
RSS 0.91, RSS 0.92, RSS 0.93, RSS 0.94, RSS 1.0, RSS 2.0, Atom 0.3, Atom 1.0 and
CDF](https://pythonhosted.org/feedparser/) feeds from a URL (optionally by being
respectful of both your bandwidth and the feed host's by using HTTP ETag and
Last-Modified headers), a local file or a string.

## Installation

Requirements: Python 2.6+ or Python 3+, *sh. (In other words, it should work on
anything except Microsoft Windows provided you have a somewhat up-to-date Python
version installed. If you'd like to support Microsoft Windows it's certainly
doable, [/priv/install.sh](/priv/install.sh) is a good starting point.)

### Production

1. Add `{:feederer, git: "https://github.com/draftli/feederer.git", tag: "v0.5.1"}`
to your `mix.exs` dependencies.
2. Add `:feederer` to your `applications` in `mix.exs`:
`[applications: […, :feederer]]`
3. Install `erlport==0.6` and `feedparser==5.2.1` using `pip` or `easy_install`.
Your Elixir application will need access to these so make sure they are either
installed globally or add their location to your application PATH.
4. Make sure `python` will be available to the application as well.
5. Read the *Configuration* section below to customize the python env, path and
command.

### Development

1. Add `{:feederer, git: "https://github.com/draftli/feederer.git", tag: "v0.5.1"}`
to your `mix.exs` dependencies.
2. Add `:feederer` to your `applications` in `mix.exs`:
`[applications: […, :feederer]]`
3. Run `mix feedparser.install` to install the python feedparser dependencies.
4. Configuration is not necessary at this point, Feederer comes with sensible
defaults. Take a look at *Configuration* below anyway.

## Configuration

Configuration is optional, everything has default values.

1. Configuration should go your application `config/` directory.
2. `erlport` keyword list: anything allowed by
[`python.start/1`](http://erlport.org/docs/python.html#erlang-api). It's the
right place to tell erlport about your python path, env, name.
3. `poolboy` keyword list: anything allowed as second argument (`poolArgs`) to
[`poolboy.child_spec/3`](https://github.com/devinus/poolboy#options) except
`name` and `worker_module` (these two will be ignored and set to default
values).
4. `supervisor_strategy` keyword: Supervisor strategy for Feederer worker pool.

Sample configuration:

```elixir
# In your config/config.exs file
config :feederer,
  erlport: [
    python_path: to_char_list("/python/dependencies/folder/"),
    compressed: 6,
    python: 'python'
  ],
  poolboy: [
    size: 10,
    max_overflow: 0
  ],
  supervisor_strategy: :one_for_one
```

## Usage

### Parsing a distant feed:

```elixir
url = "http://www.rssboard.org/files/sample-rss-2.xml"
{:ok, parsed} = Feederer.parse(url)
feed_link = parsed[:feed][:link] # "http://liftoff.msfc.nasa.gov/"
```

### Parsing a local file:

```elixir
file = File.read! @rss_file
{:ok, parsed} = Feederer.parse(file)
feed_title = parsed[:feed][:title] # the feed title
```

### Passing extra arguments to feedparser:

Use a keyword list as `Feederer.parse` second argument. Allowed arguments are:
`etag`, `modified`, `agent`, `referrer`, `request_headers`,
`response_headers`.

See [feedparser documentation](https://pythonhosted.org/feedparser/) for more
information about these arguments.

```elixir
{:ok, parsed} = Feederer.parse(file, etag: foo, request_headers: bar)
```

More usage examples: See [/test/feederer_test.exs](/test/feederer_test.exs)
