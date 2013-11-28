
# Create it
tmux new-session -d -s ops
tmux rename-window 'mv@here'

# Down: syslog
tmux select-window -t ops:0
tmux split-window  -v -t 0
tmux send-keys 'sudo tail -f /var/log/messages' 'C-m'

# Right: htop
tmux select-window -t ops:0
tmux split-window -h -t 0
tmux send-keys 'htop' 'C-m'

# One more: sudo
tmux split-window -v -t 0
tmux send-keys 'sudo su -' 'C-m'

# Use it
tmux select-window -t ops:0
tmux -2 attach-session -t ops


