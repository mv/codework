#!/bin/bash
#
# To be called by Transmission.app
#
# 2011/05
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com.

# echo "   TR_APP_VERSION $TR_APP_VERSION"
# echo "    TR_TORRENT_ID $TR_TORRENT_ID"
# echo "TR_TIME_LOCALTIME $TR_TIME_LOCALTIME"
# echo "  TR_TORRENT_HASH $TR_TORRENT_HASH"
# echo "   TR_TORRENT_DIR $TR_TORRENT_DIR"
# echo "  TR_TORRENT_NAME $TR_TORRENT_NAME"

DIR=~/bin/
LOG=/tmp/transmission.my.log

exec >> $LOG

# log entry
echo "$( /bin/date '+%Y-%m-%d %H:%M' ): ${TR_TORRENT_DIR}/${TR_TORRENT_NAME}"

# Remove [VTV]
$DIR/rename-vtv.pl ${TR_TORRENT_DIR}/${TR_TORRENT_NAME}

# End
echo
echo


