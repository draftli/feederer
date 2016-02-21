#!/bin/sh -e

# Do this from the current directory
cd `dirname $0`

# Install these packages in the current directory
pip install --install-option="--prefix=`pwd`" erlport==0.6
pip install --install-option="--prefix=`pwd`" feedparser==5.2.1

# Move erlport python sources here
mv lib/*/site-packages/erlport .
# Move feedparser.py source here
mv lib/*/site-packages/feedparser.py .

# Replace feedparserport's shebang with the local python path
sed -i -re '1s%#!.*%#!'`which python`'%' feedparserport.py

# We don't need this anymore, it's where pip installed the packages
rm -rf lib

# Get ready for work by compiling the python scripts
python -m compileall .
