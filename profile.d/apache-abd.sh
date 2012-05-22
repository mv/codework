#
# profile.d/php-abd.sh
#
# Apache env, if needed
#
# Marcus Vinicius Ferreira               ferreira.mv[ at ]gmail.com
# 2011/07
#


echo $PATH            | egrep -q "(^|:)\/abd\/ws\/apache\/bin($|:)"       || export            PATH=/abd/ws/apache/bin:$PATH
echo $LD_LIBRARY_PATH | egrep -q "(^|:)\/abd\/ws\/apache\/lib\/libl($|:)" || export LD_LIBRARY_PATH=/abd/ws/apache/lib:$LD_LIBRARY_PATH


