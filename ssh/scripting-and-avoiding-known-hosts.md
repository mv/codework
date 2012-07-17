
# Avoiding known_hosts

    ssh -o StrictHostKeyChecking=no     \
        -o UserKnownHostsFile=/dev/null \
        user@host 'hostname -s'

### using ~/.ssh/config
    Host script-target
        Hostname 192.168.1.11
        User script-user
        UserKnownHostsFile=/dev/null
        StrictHostKeyChecking=no
        

### cmd

    ssh script-target 'hostname -s'
    
    