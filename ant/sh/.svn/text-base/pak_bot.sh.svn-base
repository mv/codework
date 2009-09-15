#!/bin/bash
#
# $Id: pak_bot.sh 6 2006-09-10 15:35:16Z marcus $

cd ..

FILE=mv_bot.tar

tar cvf $FILE       \
        bot/bot*txt \
        bot/build.xml   bot/tst         bot/run.sql \
        bot/mbot.sh     bot/verify.sh               \
        bot/ping.pl

gzip -f $FILE

