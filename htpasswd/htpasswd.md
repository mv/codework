
# Pick a new user/password:
USERNAME=my.user.name
PASSWORD=my.pass.word

# encode them in SHA format, please:
htpasswd -nbs   $USERNAME  $PASSWORD

# or (ask me for the script)
htpasswd.pl  $USERNAME  $PASSWORD

