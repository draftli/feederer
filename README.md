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
anything except Microsoft Windows. If you'd like to support Microsoft Windows
it's certainly doable, [/priv/install.sh](/priv/install.sh) is a good starting
point.)

1. Add `{:erlport, git: "https://github.com/vhf/feederer.git", tag: "v0.4"}` to
your `mix.exs` dependencies.
2. Run `mix feedparser.install` to install the python feedparser dependencies.

## Configuration

You can optionally configure the pool size in `mix.exs`, under `application`.
See `poolboy_config` in `feederer.ex` to see what is configurable.

## Usage

Parsing a distant feed:

```elixir
url = "http://www.rssboard.org/files/sample-rss-2.xml"
{:ok, parsed} = Feederer.parse(url)
feed_link = parsed[:feed][:link] # "http://liftoff.msfc.nasa.gov/"
```

Parsing a local file:

```elixir
file = File.read! @rss_file
{:ok, parsed} = Feederer.parse(file)
feed_title = parsed[:feed][:title] # the feed title
```

Passing extra arguments to feedparser:

Use a keyword list as `Feederer.parse` second argument. Allowed arguments are:
`etag`, `modified`, `agent`, `referrer`, `request_headers`,
`response_headers`.

See [feedparser documentation](https://pythonhosted.org/feedparser/) for more
information about these arguments.

```elixir
{:ok, parsed} = Feederer.parse(file, etag: foo, request_headers: bar)
```

More usage examples: See [/test/feederer_test.exs](/test/feederer_test.exs)
