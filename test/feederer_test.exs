defmodule FeedererTest do
  use ExUnit.Case

  @sample_atom "test/sample-atom-1.xml"
  @sample_rss "test/sample-rss-2.xml"

  test "parsing atom file" do
    feed = File.read! @sample_atom
    {:ok, parsed} = Feederer.parse(feed)
    assert parsed[:feed][:title] == "Some Awesome Blog"
    assert parsed[:bozo] == nil

    sub_url = parsed[:feed][:links]
              |> Enum.find(fn(x) -> x[:rel] == "hub" end)
              |> Keyword.get(:href)
    assert sub_url == "https://example.com/?pushpress=hub"
  end

  test "parsing rss file" do
    file = File.read! @sample_rss
    {:ok, parsed} = Feederer.parse(file)
    assert parsed[:feed][:title] == "Liftoff News"
    assert parsed[:bozo] == nil

    sub_url = parsed[:feed][:links]
              |> Enum.find(fn(x) -> x[:rel] == "alternate" end)
              |> Keyword.get(:href)
    assert sub_url == "http://liftoff.msfc.nasa.gov/"
  end

  test "parsing rss url" do
    url = "http://www.rssboard.org/files/sample-rss-2.xml"
    {:ok, parsed} = Feederer.parse(url)
    assert parsed[:feed][:link] == "http://liftoff.msfc.nasa.gov/"
    assert parsed[:bozo] == nil
  end

  test "parsing rss url with headers" do
    url = "http://www.rssboard.org/files/sample-rss-2.xml"
    {:ok, parsed} = Feederer.parse(url)
    assert parsed[:bozo] == nil

    etag = parsed[:etag]
    {:ok, should304} = Feederer.parse(url, [etag: etag, hello: "lol"])
    assert should304[:status] == 304
    assert should304[:bozo] == nil


    modified = parsed[:headers]
                      |> Enum.find(fn(x) -> elem(x, 0) == "last-modified" end)
                      |> elem(1)

    {:ok, should304} = Feederer.parse(url, [modified: modified])
    assert should304[:status] == 304
    assert should304[:bozo] == nil

    {:ok, should304} = Feederer.parse(url, [etag: etag, modified: modified])
    assert should304[:status] == 304
    assert should304[:bozo] == nil
  end

  test "feed not found" do
    url = "http://www.rssboard.org/files/sample-rss-roger-federer.xml"
    {:ok, should404} = Feederer.parse(url)
    assert should404[:status] == 404
    assert should404[:bozo] == 1
  end

  test "bozo feed" do
    url = "http://www.rssboard.org/"
    {:ok, parsed} = Feederer.parse(url)
    assert parsed[:bozo] == 1
  end

end
