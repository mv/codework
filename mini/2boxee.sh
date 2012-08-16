#!/bin/bash
#
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-08
#

set -x

rsync -avhiP --size-only        \
    /Users/mini/Movies/Cinema/  \
    /Volumes/movies/Acervo/Cinema/

rsync -avhiP --size-only        \
    /Users/mini/Movies/TV/      \
    /Volumes/movies/Acervo/tv/


