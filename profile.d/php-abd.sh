#
# profile.d/php-abd.sh
#
# PHP env, if needed
#
# Marcus Vinicius Ferreira               ferreira.mv[ at ]gmail.com
# 2011/07
#


echo $PATH            | egrep -q "(^|:)\/abd\/local\/bin($|:)" || export            PATH=/abd/local/bin:$PATH
echo $LD_LIBRARY_PATH | egrep -q "(^|:)\/abd\/local\/lib($|:)" || export LD_LIBRARY_PATH=/abd/local/lib:$LD_LIBRARY_PATH


