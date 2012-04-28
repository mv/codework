# Package Names

    name 
    name.arch 
    name-ver 
    name-ver-rel 
    name-ver-rel.arch 
    name-ver-rel.repo
    name-ver-rel.repo.arch 
    name-ver-rel.vendor
    name-ver-rel.vendor.arch 
    name-ver-rel.repo.vendor
    name-ver-rel.repo.vendor.arch 
    name-epoch:ver-rel.arch 
    epoch:name-ver-rel.arch

### Examples

    MySQL-client
    MySQL-client.x86_64
    MySQL-client-5.5.21
    MySQL-client-5.5.21-1
    MySQL-client-5.5.21-1.x86_64
    MySQL-client-5.5.21-1.el5
    MySQL-client-5.5.21-1.el5.x86_64
    mysql-client-5.5.21-1.amzn
    mysql-client-5.5.21-1.amzn.x86_64
    mysql-client-5.5.21-1.abril
    mysql-client-5.5.21-1.abril.x86_64
    MySQL-client-5.5.21-1.el5.abril
    MySQL-client-5.5.21-1.el5.abril.x86_64

# Directories/Files

    # Main config
    /etc/yum.conf

    # Repositories
    /etc/yum.repos.d/
    /etc/yum.repos.d/repos1.repo
    /etc/yum.repos.d/repos2.repo

    # Plugins
    /etc/yum/pluginconf.d/fastestmirror.conf

    # Downloads
    /var/cache/yum
    
    # GPG keys
    /etc/pki/rpm-gpg/RPM-GPG-KEY-*
    

# Authorizing Package sources

    rpm --import RPM-GPG-KEY-provider.asc
    rpm --import http://provider.com/RPM-GPG-KEY-provider.asc

    
# Commands

### Using a Repo

    # configured repos
    yum repolist
    
    # Using a specific repo only
    yum --disablerepo=\* --enablerepo=c5-media
    
    # Enable a repo
    
    # Disable a repo
    
### Cleanup

    # Remove metadata
    yum clean headers

    # Remove downloaded packages
    yum clean packages


# Plugins

### Enable plugins
    
    # /etc/yum.conf
    plugins=1:w
    
### Fastest plugin

    # Install
    yum install yum-plugin-fastestmirror
    
    # /etc/yum/pluginconf.d/fastestmirror.conf
    [main]
    verbose = 0
    socket_timeout = 3
    enabled = 1
    hostfilepath = /var/cache/yum/timedhosts.txt
    maxhostfileage = 1
    
# Yum-utils

    # Install
    yum install yum-utils
    
    # Utils
    repo-graph
    repomanage

# Arch

    noarch     - Compatible with all computer architectures
    i386       - Suitable for any current Intel®-compatible computer
    i586       - 32bits, Intel Pentium and above
    i686       - 32bits, Intel Pentium Pro, AMD and above
    x86_64     - Suitable for 64-bit Intel-compatible processors:AMD, Xeon
    ia64       - Suitable for Intel® Itanium2 processors.
    ppc        - Suitable for PowerPC systems
    s390/s390x - Suitable for IBM® S390 or S390x Processors.
    alpha      - Suitable for DEC® alpha Processors (now owned by Hewlitt Packard®).
    sparc      - Suitable for Sun Microsystems® sparc Processors.

    
### Ref
    
http://yum.baseurl.org/wiki/YumUtils
    
        
# References

    http://www.centos.org/docs/5/html/yum/index.html
    http://www.centos.org/docs/5/html/yum/sn-yum-maintenance.html
    
    http://yum.baseurl.org/wiki/Guides
    