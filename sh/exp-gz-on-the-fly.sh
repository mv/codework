# To export to a compressed file:

# pipe fisico:
#   mkfifo
#   mknode

mkfifo pipe.dmp
compress < pipe.dmp > expdat.dmp.Z &
exp user/passwd full=y file=pipe.dmp

# To import the same file:

mkfifo pipe.dmp
uncompress < expdat.dmp.Z > pipe.dmp &
imp user/passwd full=y file=pipe.dmp

