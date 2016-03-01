#!/bin/sh -e

# Do this from the current directory
cd `dirname $0`

# Remove previous erlport install if it exists (otherwise mv will faild)
>&2 echo ">>> Removing previously installed files (if any)"
rm -fv ./erlport/* 1>&2

# Install these packages in the current directory
>&2 echo ">>> Locally installing erlport and feedparser python libraries"
pip install --install-option="--prefix=`pwd`" --force-reinstall erlport==0.6
pip install --install-option="--prefix=`pwd`" --force-reinstall feedparser==5.2.1

>&2 echo ">>> Moving python libraries to a nicer place"
# Move erlport python sources here
mv -v lib/*/site-packages/erlport . 1>&2
# Move feedparser.py source here
mv -v lib/*/site-packages/feedparser.py . 1>&2

# Replace feedparserport's shebang with the local python path
sed -i -re '1s%#!.*%#!'`which python`'%' feedparserport.py

>&2 echo ">>> Removing python libraries unneeded extra files"
# We don't need this anymore, it's where pip installed the packages
rm -rfv ./lib/ 1>&2

# Get ready for work by compiling the python scripts
python -m compileall .
