
# Enable Spotlight

### Daemon
    sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

### Index
    sudo mdutil -a -i on



# Disable Spotlight

### Daemon
    sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

### Index
    sudo mdutil -a -i off
    sudo mdutil -E /

