

find . -type d -exec chmod 775 {} \; -ls
find . -type f -exec chmod 664 {} \; -ls

find . -type f -name "*sh"  -exec chmod 775 {} \; -ls
find . -type f -name "*pl"  -exec chmod 775 {} \; -ls
find . -type f -name "*awk" -exec chmod 775 {} \; -ls
find . -type f -name "*exe" -exec chmod 775 {} \; -ls

