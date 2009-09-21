#!/bin/bash
#
# Current script absolute path
#
# Marcus Vinicius Ferreira                  ferreira.mv[ at ]gmail.com
# 2009/09
#

set -x
my_abs_path=$( cd ${0%/*} && echo $PWD/${0##*/} )
my_dir_path=$( cd ${0%/*} && echo $PWD )


