
# Refeference

    http://danielmiessler.com/study/tcpdump/

### saving to file
tcpdump -i eth1 'tcp port 80 and src 172.16.16.173 ' -w /tmp/dump1.txt

### NO resolve
tcpdump -i eth1 -n 'tcp port 80 and src 172.16.16.173 ' 2>&1 | tee /tmp/dump2.txt

## Cases

### Bracce: ftps

    # all traffic to/from a single host
    tcpdump -nnS -i eth0 host 201.85.67.102


