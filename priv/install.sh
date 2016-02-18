#!/bin/sh -e

cd `dirname $0`
[ -f feedparser.py ] && exit 0
rm -rf env feedparser.py *.pyc

pip install --install-option="--prefix=`pwd`" erlport==0.6
pip install --install-option="--prefix=`pwd`" feedparser==5.2.1

mv lib/*/site-packages/erlport .
mv lib/*/site-packages/feedparser.py .

sed -i -re '1s%#!.*%#!'`which python`'%' feedparserport.py

rm -rf lib

python -m compileall .
