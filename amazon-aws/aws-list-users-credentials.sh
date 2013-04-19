
aws lu --simple | awk '{print $3}' | while read usr; do aws userlistkeys -u $usr --simple ; done

