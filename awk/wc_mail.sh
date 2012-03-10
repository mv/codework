
awk '{Lines = NR; Words += NF } END{ print Lines, Words }' longmail.txt

