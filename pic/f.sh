

find . -type f | egrep -i 'pic|img|vid|\.mp?|\.flv|\.wmf|\.av?|\.png|\.jpg|\.gif|\.bmp|\.zip' \
     | tee find.pic.txt

