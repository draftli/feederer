#!/usr/local/bin/python
# Parts of this file inspired by https://github.com/urbanserj/feedparser/
# Copyright (C) 2011, 2012 by Sergey Urbanovich - MIT License
# Copyright (C) 2016 by Draft authors - MIT License
import time
import feedparser

from erlport.erlterms import Atom

feedparser.USER_AGENT = "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko) \
Chrome/50.0.2638.0 Safari/537.36 Draft/Feederer"

all_tags = ['author', 'author_detail', 'base', 'bozo', 'bozo_exception',
            'cloud', 'comments', 'content', 'contributors', 'created',
            'created_parsed', 'description', 'docs', 'domain', 'email',
            'enclosures', 'encoding', 'entries', 'errorreportsto', 'etag',
            'expired', 'expired_parsed', 'feed', 'generator',
            'generator_detail', 'headers', 'height', 'href', 'icon', 'id',
            'image', 'info', 'info_detail', 'label', 'language', 'length',
            'license', 'link', 'links', 'logo', 'modified', 'name',
            'namespaces', 'path', 'port', 'protocol', 'published',
            'published_parsed', 'publisher', 'publisher_detail',
            'registerProcedure', 'rel', 'rights', 'rights_detail', 'scheme',
            'source', 'status', 'subtitle', 'subtitle_detail', 'summary',
            'summary_detail', 'tags', 'term', 'textinput', 'title',
            'title_detail', 'ttl', 'type', 'updated', 'updated_parsed',
            'value', 'version', 'width']


def py2erl(term, root):
    """
    Converts the big feedparser dict output into a big Erlang tuple
    """
    if isinstance(term, dict) and root in ['namespaces', 'headers']:
        return [(py2erl(key, root), py2erl(value, root))
                for key, value in term.items()]

    if isinstance(term, dict):
        return [(Atom(key), py2erl(value, key))
                for key, value in term.items() if value and key in all_tags]

    if isinstance(term, tuple):
        return (py2erl(t, root) for t in term)

    if isinstance(term, list):
        return [py2erl(t, root) for t in term]

    if isinstance(term, bool):
        return term

    if isinstance(term, str):
        return term

    if isinstance(term, unicode):
        return term.encode('utf8')

    if isinstance(term, (int, long, float)):
        return term

    if isinstance(term, time.struct_time):
        return time.strftime("%a, %d %b %Y %H:%M:%S", term)

    # repr the extra stuff, should not happen
    term = term.__repr__()
    return term.encode('utf8')


def test(url_filepath_or_string, *args):
    args = [arg if arg else None for arg in args]

    try:
        feed = feedparser.parse(url_filepath_or_string, *args)
    except:
        return (Atom('error'), Atom('feedparser failed'))
    finally:
        return (Atom('ok'), py2erl(feed, None))
