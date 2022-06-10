#!/bin/sh
docker run -it --rm \
    --volume="$( dirname "$PWD" ):/srv/jekyll" \
    -p 4000:4000 jekyll/jekyll \
    jekyll serve
