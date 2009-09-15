<html><head><title>kstats.py</title></head><body bgcolor="#ffffff">
		  <!--header-->
		  <!--script--><pre><font color="#1111cc">#!/s/bin/python -- # -*- python -*-</font>
<font color="#1111cc"># $Id: kstats.py 6 2006-09-10 15:35:16Z marcus $</font>
<font color="#1111cc"># $Source: /u/annis/code/NewMom/kstat/RCS/kstats.py,v $</font>
<font color="#1111cc">#</font>
<font color="#1111cc"># Copyright (c) 1999-2001 William S. Annis.  All rights reserved.</font>
<font color="#1111cc"># This is free software; you can redistribute it and/or modify it</font>
<font color="#1111cc"># under the same terms as Perl (the Artistic Licence).  Developed at</font>
<font color="#1111cc"># the Department of Biostatistics and Medical Informatics, University</font>
<font color="#1111cc"># of Wisconsin, Madison.</font>


<font color="#115511">"""User-friendly interface to the Solaris kstat(3k) library.

While this interface is more user-friendly than the SWIG interface to
kstat(3k), there are parts that aren't going to be useful to anyone
who doesn't know, say, the differences between NFS versions 2 and 3.

Recommended man pages to enhance understanding: netstat, nfsstat,
iostat.  The NFS and RPC statistics in particular are best understood
with help from the man page for nfsstat.

In order to limit the amount chain traversing going on, this API has a
sample rate.  Every query runs a check agains the last query time to
determine if the chain needs to be searched again.  The default sample
rate is 5 seconds.
"""</font>

<font color="#3333cc"><b>from</b></font> kstat <font color="#3333cc"><b>import</b></font> Kstat
<font color="#3333cc"><b>from</b></font> time <font color="#3333cc"><b>import</b></font> time
<font color="#3333cc"><b>import</b></font> string


__kst = None                            <font color="#1111cc"># Kstat instance</font>
__kst_ts = None                         <font color="#1111cc"># time-stamp of last chain update</font>
__kst_sr = 5                            <font color="#1111cc"># sample rate, in seconds</font>
__kst_watching = {}                     <font color="#1111cc"># dictionary of stats watched</font>
__pti = None                            <font color="#1111cc"># /etc/path_to_inst data</font>
__devdsk = None                         <font color="#1111cc"># links from /dev/dsk</font>

<font color="#3333cc"><b>class</b></font><a name=" KstatsNoSuchDevice"><font color="#cc0000"><b> KstatsNoSuchDevice</b></font>(Exception):
    <font color="#3333cc"><b>pass</b></font>

<font color="#1111cc"># This is very useful for information about disks.  The kstat interface</font>
<font color="#1111cc"># still uses the SunOS names (sd0a, etc.), but us Solaris geeks like to</font>
<font color="#1111cc"># see c0t3d0s0. </font>
<font color="#1111cc"># Kstat returns partition names like 'sd3,a', so that's what this expects.</font>
<font color="#3333cc"><b>def</b></font></a><a name=" sd_to_ctds"><font color="#cc0000"><b> sd_to_ctds</b></font>(sd):
    <font color="#115511">"""Convert something like 'sd0,a' into 'c0t3d0s0'.

    This can also (attempt to) convert names such as 'sd0' into
    'c0t3d0' for full disks.
    """</font>
    <font color="#3333cc"><b>import</b></font> os

    <font color="#3333cc"><b>if</b></font> __pti <font color="#3333cc"><b>is</b></font> None:
        <font color="#1111cc"># If this hasn't been intialized, neither has __devdsk...</font>
        __read_devdsk()
        __read_path_to_inst()

    <font color="#3333cc"><b>if</b></font> sd[-2] == <font color="#115511">","</font>:
        part = <font color="#115511">":"</font> + sd[-1]
        sd = sd[:-2]
        partition = 1
    <font color="#3333cc"><b>else</b></font>:
        <font color="#1111cc"># There is no /dev/sd3, so fake out the disk name by asking</font>
        <font color="#1111cc"># for the first slice, then chopping off that part of the name</font>
        <font color="#1111cc"># later.</font>
        part = <font color="#115511">":a"</font>
        partition = 0

    <font color="#3333cc"><b>if</b></font> __pti.has_key(sd):
        <font color="#3333cc"><b>if</b></font> partition:
            <font color="#3333cc"><b>return</b></font> __devdsk[__pti[sd] + part]
        <font color="#3333cc"><b>else</b></font>:
            <font color="#3333cc"><b>return</b></font> __devdsk[__pti[sd] + part][:-2]
    <font color="#3333cc"><b>else</b></font>:
        <font color="#1111cc"># Are you on the right machine?</font>
        <font color="#3333cc"><b>return</b></font> sd

<font color="#3333cc"><b>def</b></font></a><a name=" ctds_to_sd"><font color="#cc0000"><b> ctds_to_sd</b></font>(ctds):
    <font color="#115511">"""Convert c0t0d0s0 into something like 'sd0,a'."""</font>
    <font color="#3333cc"><b>import</b></font> os

    <font color="#3333cc"><b>if</b></font> ctds[-2] == <font color="#115511">'s'</font>:
        path = ctds
        partition = 1
    <font color="#3333cc"><b>else</b></font>:
        path = ctds + <font color="#115511">'s0'</font>
        partition = 0

    <font color="#3333cc"><b>try</b></font>:
        devname = os.path.basename(os.readlink(<font color="#115511">"/dev/dsk/"</font> + path))
    <font color="#3333cc"><b>except</b></font>:
        <font color="#3333cc"><b>raise</b></font> KstatsNoSuchDevice, path

    <font color="#1111cc"># Now, turn the name of the device into something kstat knows about.</font>
    part = devname[-1]
    (driver, no) = string.split(devname[:-2], <font color="#115511">"@"</font>)
    no = string.split(no, <font color="#115511">","</font>)[0]

    <font color="#3333cc"><b>if</b></font> partition:
        <font color="#3333cc"><b>return</b></font> driver + no + <font color="#115511">","</font> + part
    <font color="#3333cc"><b>else</b></font>:
        <font color="#3333cc"><b>return</b></font> driver + no

<font color="#1111cc"># __read_path_to_inst and __read_devdsk together generate dictionaries</font>
<font color="#1111cc"># used by the current sd_to_ctds function.  /etc/path_to_inst is</font>
<font color="#1111cc"># parsed and generates a dict keyed on driver + instance name.  So,</font>
<font color="#1111cc"># an entry like this:</font>
<font color="#1111cc">#</font>
<font color="#1111cc">#     "/sbus@1f,0/SUNW,fas@e,8800000/sd@0,0" 0 "sd"</font>
<font color="#1111cc">#</font>
<font color="#1111cc"># and enter it into the dictionary as:</font>
<font color="#1111cc">#</font>
<font color="#1111cc">#    __pti['sd0'] = "/sbus@1f,0/SUNW,fas@e,8800000/sd@0,0"</font>
<font color="#1111cc">#</font>
<font color="#1111cc"># This is used with the dictionary of /dev/dsk/* names, which are all</font>
<font color="#1111cc"># symbolic links to something that looks much like the value above.</font>
<font color="#1111cc"># See sd_to_ctds for the chain of dictionary lookups.</font>
<font color="#1111cc"># Some munching needs to be done to get information on an entire disk</font>
<font color="#1111cc"># rather than just a partition.</font>
<font color="#3333cc"><b>def</b></font></a><a name=" __read_path_to_inst"><font color="#cc0000"><b> __read_path_to_inst</b></font>():
    <font color="#3333cc"><b>global</b></font> __pti
    __pti = {}

    p = open(<font color="#115511">"/etc/path_to_inst"</font>, <font color="#115511">"r"</font>)
    <font color="#3333cc"><b>for</b></font> line <font color="#3333cc"><b>in</b></font> p.readlines():
        <font color="#3333cc"><b>if</b></font> line[0] == <font color="#115511">"#"</font>: <font color="#3333cc"><b>continue</b></font>
        string.strip(line)
        (pname, inst, driver) = string.split(line)

        <font color="#1111cc"># Chop of leading and trailing quotes.</font>
        pname = pname[1:-1]
        driver = driver[1:-1]

        __pti[driver + inst] = pname

    p.close()
    <font color="#1111cc">#print </font>__pti, __devdsk

<font color="#1111cc"># This generates a full dictionary of /dev/dsk/* links.</font>
<font color="#3333cc"><b>def</b></font></a><a name=" __read_devdsk"><font color="#cc0000"><b> __read_devdsk</b></font>():
    <font color="#3333cc"><b>global</b></font> __devdsk
    <font color="#3333cc"><b>import</b></font> glob, os

    __devdsk = {}
    <font color="#3333cc"><b>for</b></font> dsk <font color="#3333cc"><b>in</b></font> glob.glob(<font color="#115511">'/dev/dsk/*'</font>):
        dev = os.readlink(dsk)
        <font color="#1111cc"># Chop off the /dev/dsk and ../../devices grot, too.</font>
        __devdsk[dev[13:]] = dsk[9:]

<font color="#3333cc"><b>def</b></font></a><a name=" __setup_kstat"><font color="#cc0000"><b> __setup_kstat</b></font>():
    <font color="#3333cc"><b>global</b></font> __kst, __kst_ts

    __kst = Kstat()
    __kst_ts = time() + __kst_sr

<font color="#3333cc"><b>def</b></font></a><a name=" __kstat_update"><font color="#cc0000"><b> __kstat_update</b></font>(forced=0):
    <font color="#115511">"""Update the Kstat instance if it's time to do so.

    An update can be forced with __kstat_update(forced=1).  Returns 1
    if there was an update, or 0 if not.
    """</font>
    <font color="#3333cc"><b>global</b></font> __kst_ts

    <font color="#3333cc"><b>if</b></font> forced <font color="#3333cc"><b>or</b></font> time() &gt; __kst_ts:
        __kst.update()
        __kst_ts = time() + __kst_sr
        <font color="#3333cc"><b>return</b></font> 1
    <font color="#3333cc"><b>else</b></font>:
        <font color="#3333cc"><b>return</b></font> 0

<font color="#3333cc"><b>def</b></font></a><a name=" set_sample_rate"><font color="#cc0000"><b> set_sample_rate</b></font>(sr):
    <font color="#115511">"""Set the sample rate, in seconds.

    Resets the current sample time sensibly.
    """</font>
    <font color="#3333cc"><b>global</b></font> __kst_ts, __kst_sr

    <font color="#1111cc"># Reset the time stamp first.</font>
    __kst_ts = __kst_ts + (sr - __kst_sr)
    <font color="#1111cc"># Now change the sample rate.</font>
    __kst_sr = sr

<font color="#3333cc"><b>def</b></font></a><a name=" get_sample_rate"><font color="#cc0000"><b> get_sample_rate</b></font>():
    <font color="#3333cc"><b>return</b></font> __kst_sr

<font color="#3333cc"><b>def</b></font></a><a name=" watching"><font color="#cc0000"><b> watching</b></font>():
    <font color="#115511">"""What statistics are being watched."""</font>
    <font color="#3333cc"><b>return</b></font> __kst_watching.keys()

<font color="#3333cc"><b>def</b></font></a><a name=" is_watching"><font color="#cc0000"><b> is_watching</b></font>(stat):
    <font color="#115511">"""Is this measure being watched?

    if is_watching('load'):
        do_something_with_the_load()
    """</font>
    <font color="#3333cc"><b>return</b></font> __kst_watching.has_key(stat)

<font color="#1111cc"># When you watch something new, there is a forced update of the chain</font>
<font color="#1111cc"># to get the new data in.</font>
<font color="#3333cc"><b>def</b></font></a><a name=" _watch"><font color="#cc0000"><b> _watch</b></font>(name_, module, instance, name, id=None):
    __kst_watching[name_] = 1
    __kst.watch(module, instance, name, id)
    __kstat_update(forced=1)

<font color="#3333cc"><b>def</b></font></a><a name=" load"><font color="#cc0000"><b> load</b></font>():
    <font color="#115511">"""Current 1, 5 and 15 minute load averages."""</font>
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(<font color="#115511">'load'</font>):
        _watch(<font color="#115511">'load'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'system_misc'</font>, id=<font color="#115511">'load'</font>)

    __kstat_update()
    l = __kst.get(<font color="#115511">'load'</font>)[0]

    <font color="#3333cc"><b>return</b></font> (l[<font color="#115511">'avenrun_1min'</font>] / 256.0,
            l[<font color="#115511">'avenrun_5min'</font>] / 256.0,
            l[<font color="#115511">'avenrun_15min'</font>] / 256.0)

<font color="#3333cc"><b>def</b></font></a><a name=" nprocs"><font color="#cc0000"><b> nprocs</b></font>():
    <font color="#115511">"""Number of current processes."""</font>
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(<font color="#115511">'load'</font>):
        _watch(<font color="#115511">'load'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'system_misc'</font>, id=<font color="#115511">'load'</font>)

    __kstat_update()
    l = __kst.get(<font color="#115511">'load'</font>)[0]

    <font color="#3333cc"><b>return</b></font> l[<font color="#115511">'nproc'</font>]

<font color="#3333cc"><b>def</b></font></a><a name=" boottime"><font color="#cc0000"><b> boottime</b></font>():
    <font color="#115511">"""When the machine was last boot."""</font>
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(<font color="#115511">'load'</font>):
        _watch(<font color="#115511">'load'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'system_misc'</font>, id=<font color="#115511">'load'</font>)

    __kstat_update()
    l = __kst.get(<font color="#115511">'load'</font>)[0]

    <font color="#3333cc"><b>return</b></font> l[<font color="#115511">'boot_time'</font>]

<font color="#3333cc"><b>def</b></font></a><a name=" diskerrs"><font color="#cc0000"><b> diskerrs</b></font>(disk=None):
    <font color="#115511">"""Get disk information and errors."""</font>
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(<font color="#115511">'sderr'</font>):
        _watch(<font color="#115511">'sderr'</font>, <font color="#115511">'sderr'</font>, None, None, id=<font color="#115511">'sderr'</font>)
        _watch(<font color="#115511">'daderr'</font>, <font color="#115511">'daderror'</font>, None, None, id=<font color="#115511">'daderr'</font>)

    __kstat_update()

    dsks = []
    <font color="#3333cc"><b>try</b></font>:
        dsks = dsks + __kst.get(<font color="#115511">'sderr'</font>)
        dsks = dsks + __kst.get(<font color="#115511">'daderr'</font>)
    <font color="#3333cc"><b>except</b></font>:
        <font color="#3333cc"><b>pass</b></font>

    <font color="#3333cc"><b>if</b></font> disk:
        <font color="#3333cc"><b>for</b></font> d <font color="#3333cc"><b>in</b></font> dsks:
            <font color="#3333cc"><b>if</b></font> d.record[2] == <font color="#115511">"%s,err"</font> % disk:
                <font color="#3333cc"><b>return</b></font> d

        <font color="#3333cc"><b>raise</b></font> KstatsNoSuchDevice, disk
    <font color="#3333cc"><b>else</b></font>:
        <font color="#3333cc"><b>try</b></font>:
            <font color="#3333cc"><b>return</b></font> __kst.get(<font color="#115511">'sderr'</font>)
        <font color="#3333cc"><b>except</b></font>:
            <font color="#3333cc"><b>return</b></font> __kst.get(<font color="#115511">'daderr'</font>)
diskinfo = diskerrs

<font color="#1111cc"># The statistics for RPC and NFS which come out of nfsstat are spread</font>
<font color="#1111cc"># all over the kstat chain.  The cliches for extracting that information</font>
<font color="#1111cc"># are homomorphic, however, and differ only in arguments to _watch.</font>
<font color="#3333cc"><b>def</b></font></a><a name=" __rpcwrap"><font color="#cc0000"><b> __rpcwrap</b></font>(name_, mod, inst, name):
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(name_):
        _watch(name_, mod, inst, name, id=name_)

    __kstat_update()
    <font color="#3333cc"><b>return</b></font> __kst.get(name_)[0]

<font color="#3333cc"><b>def</b></font></a><a name=" rpc_client"><font color="#cc0000"><b> rpc_client</b></font>():
    <font color="#115511">"""Get RPC client information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'rpc_client'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'rpc_client'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" rpc_clts_client"><font color="#cc0000"><b> rpc_clts_client</b></font>():
    <font color="#115511">"""Get RPC (connectionless) client information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'rpc_clts_client'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'rpc_clts_client'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" rpc_cots_client"><font color="#cc0000"><b> rpc_cots_client</b></font>():
    <font color="#115511">"""Get RPC (connection oriented) client information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'rpc_cots_client'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'rpc_cots_client'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" rpc_server"><font color="#cc0000"><b> rpc_server</b></font>():
    <font color="#115511">"""Get RPC server information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'rpc_server'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'rpc_server'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" rpc_clts_server"><font color="#cc0000"><b> rpc_clts_server</b></font>():
    <font color="#115511">"""Get RPC (connectionless) server information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'rpc_clts_server'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'rpc_clts_server'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" rpc_cots_server"><font color="#cc0000"><b> rpc_cots_server</b></font>():
    <font color="#115511">"""Get RPC (connection oriented) server information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'rpc_cots_server'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'rpc_cots_server'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_server"><font color="#cc0000"><b> nfs_server</b></font>():
    <font color="#115511">"""Get NFS server base information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_server'</font>, <font color="#115511">'nfs'</font>, None, <font color="#115511">'nfs_server'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_server_v2"><font color="#cc0000"><b> nfs_server_v2</b></font>():
    <font color="#115511">"""Get NFS.v2 server information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_server_v2'</font>, <font color="#115511">'nfs'</font>, None, <font color="#115511">'rfsproccnt_v2'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_server_v3"><font color="#cc0000"><b> nfs_server_v3</b></font>():
    <font color="#115511">"""Get NFS.v3 server information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_server_v3'</font>, <font color="#115511">'nfs'</font>, None, <font color="#115511">'rfsproccnt_v3'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_client"><font color="#cc0000"><b> nfs_client</b></font>():
    <font color="#115511">"""Get NFS client base information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_client'</font>, <font color="#115511">'nfs'</font>, None, <font color="#115511">'nfs_client'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_client_v2"><font color="#cc0000"><b> nfs_client_v2</b></font>():
    <font color="#115511">"""Get NFS.v2 client information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_client_v2'</font>, <font color="#115511">'nfs'</font>, None, <font color="#115511">'rfsreqcnt_v2'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_client_v3"><font color="#cc0000"><b> nfs_client_v3</b></font>():
    <font color="#115511">"""Get NFS.v3 client information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_client_v3'</font>, <font color="#115511">'nfs'</font>, None, <font color="#115511">'rfsreqcnt_v3'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_acl_server_v2"><font color="#cc0000"><b> nfs_acl_server_v2</b></font>():
    <font color="#115511">"""Get NFS.v2 ACL server information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_acl_server_v2'</font>, <font color="#115511">'nfs_acl'</font>, None, <font color="#115511">'aclproccnt_v2'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_acl_server_v3"><font color="#cc0000"><b> nfs_acl_server_v3</b></font>():
    <font color="#115511">"""Get NFS.v3 ACL server information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_acl_server_v3'</font>, <font color="#115511">'nfs_acl'</font>, None, <font color="#115511">'aclproccnt_v3'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_acl_client_v2"><font color="#cc0000"><b> nfs_acl_client_v2</b></font>():
    <font color="#115511">"""Get NFS.v2 ACL client information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_acl_client_v2'</font>, <font color="#115511">'nfs_acl'</font>, None, <font color="#115511">'aclreqcnt_v2'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" nfs_acl_client_v3"><font color="#cc0000"><b> nfs_acl_client_v3</b></font>():
    <font color="#115511">"""Get NFS.v3 ACL client information and errors."""</font>
    <font color="#3333cc"><b>return</b></font> __rpcwrap(<font color="#115511">'nfs_acl_client_v32'</font>, <font color="#115511">'nfs_acl'</font>, None, <font color="#115511">'aclreqcnt_v3'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" cpuinfo"><font color="#cc0000"><b> cpuinfo</b></font>(cpu=None):
    <font color="#115511">"""Get CPU information.

    You can ask for info on a specific CPU by passing in the CPU number:

        info = cpuinfo(3)
    """</font>
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(<font color="#115511">'cpuinfo'</font>):
        _watch(<font color="#115511">'cpuinfo'</font>, <font color="#115511">'cpu_info'</font>, None, None, id=<font color="#115511">'cpuinfo'</font>)

    __kstat_update()

    <font color="#3333cc"><b>if</b></font> cpu:
        <font color="#3333cc"><b>for</b></font> c <font color="#3333cc"><b>in</b></font> __kst.get(<font color="#115511">'cpuinfo'</font>):
            <font color="#3333cc"><b>if</b></font> c.record[2] == <font color="#115511">"cpu_info%s"</font> % cpu:
                <font color="#3333cc"><b>return</b></font> c

        <font color="#1111cc"># If this falls through, there's a problem.</font>
        <font color="#3333cc"><b>raise</b></font> KstatsNoSuchDevice, <font color="#115511">"cpu %s"</font> % cpu
    <font color="#3333cc"><b>else</b></font>:
        <font color="#3333cc"><b>return</b></font> __kst.get(<font color="#115511">'cpuinfo'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" cpustat"><font color="#cc0000"><b> cpustat</b></font>(cpu=None):
    <font color="#115511">"""Get cpu_stat information.

    See /usr/include/sys/sysinfo.h for more information.

    You can ask for info on a specific CPU by passing in the CPU number:

        stat = cpustat(3)
    """</font>
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(<font color="#115511">'cpustat'</font>):
        _watch(<font color="#115511">'cpustat'</font>, <font color="#115511">'cpu_stat'</font>, None, None, id=<font color="#115511">'cpustat'</font>)

    __kstat_update()

    <font color="#3333cc"><b>if</b></font> cpu != None:
        <font color="#3333cc"><b>try</b></font>:
            <font color="#3333cc"><b>return</b></font> __kst.get(<font color="#115511">'cpustat'</font>)[cpu]
        <font color="#3333cc"><b>except</b></font>:
            <font color="#3333cc"><b>raise</b></font> KstatsNoSuchDevice, <font color="#115511">"cpu %s"</font> % cpu
    <font color="#3333cc"><b>else</b></font>:
        <font color="#3333cc"><b>return</b></font> __kst.get(<font color="#115511">'cpustat'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" netstat"><font color="#cc0000"><b> netstat</b></font>(interface=None):
    <font color="#115511">"""Get network statistics for all devices.

    You must ask for information about a specific device type:

        loopback = netstat('lo')
        netinfo = netstat('hme')

    Thus, if you have multiple interfaces, you'll get a list of answers.
    """</font>
    watchname = <font color="#115511">'netstat-'</font> + interface
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(watchname):
        _watch(watchname, interface, None, None, id=watchname)

    __kstat_update()
    <font color="#3333cc"><b>return</b></font> __kst.get(watchname)

<font color="#3333cc"><b>def</b></font></a><a name=" diskstat"><font color="#cc0000"><b> diskstat</b></font>(device):
    <font color="#115511">"""Get IO statistics for a partition or disk.

    This will accept disk and parition names in either format: 'sd0'
    or 'c0t3d0' for a disk, and 'sd0,a' and 'c0t3d0s0' for a partition.
    """</font>
    <font color="#1111cc"># Convert name to 'sd...' style format.</font>
    <font color="#3333cc"><b>if</b></font> device[0] == <font color="#115511">'c'</font> <font color="#3333cc"><b>and</b></font> device[2] == <font color="#115511">'t'</font>:
        device = ctds_to_sd(device)

    watchname = <font color="#115511">"diskstat-"</font> + device
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(watchname):
        _watch(watchname, None, None, device, id=watchname)

    __kstat_update()
    <font color="#3333cc"><b>return</b></font> __kst.get(watchname)

<font color="#3333cc"><b>def</b></font></a><a name=" vminfo"><font color="#cc0000"><b> vminfo</b></font>():
    <font color="#115511">"""Get information from the vminfo struct.

    See /usr/include/sys/sysinfo.h for struct details.
    """</font>
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(<font color="#115511">'vminfo'</font>):
        _watch(<font color="#115511">'vminfo'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'vminfo'</font>, id=<font color="#115511">'vminfo'</font>)

    __kstat_update()

    <font color="#3333cc"><b>return</b></font> __kst.get(<font color="#115511">'vminfo'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" sysinfo"><font color="#cc0000"><b> sysinfo</b></font>():
    <font color="#115511">"""Get information from the sysinfo struct.

    I'm not sure how useful this is.  It has only a fiew fields
    dealing with swapping and runqueue stuff.

    See /usr/include/sys/sysinfo.h for struct details.
    """</font>
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(<font color="#115511">'sysinfo'</font>):
        _watch(<font color="#115511">'sysinfo'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'sysinfo'</font>, id=<font color="#115511">'sysinfo'</font>)

    __kstat_update()

    <font color="#3333cc"><b>return</b></font> __kst.get(<font color="#115511">'sysinfo'</font>)

<font color="#3333cc"><b>def</b></font></a><a name=" ncstats"><font color="#cc0000"><b> ncstats</b></font>():
    <font color="#115511">"""Get information from the ncstats struct.

    See /usr/include/sys/dnlc.h for struct details.

    Name lookup information can be found on page 360 of 'Sun Performance
    and Tuning.'
    """</font>
    <font color="#3333cc"><b>if</b></font> <font color="#3333cc"><b>not</b></font> is_watching(<font color="#115511">'ncstats'</font>):
        _watch(<font color="#115511">'ncstats'</font>, <font color="#115511">'unix'</font>, None, <font color="#115511">'ncstats'</font>, id=<font color="#115511">'ncstats'</font>)

    __kstat_update()

    <font color="#3333cc"><b>return</b></font> __kst.get(<font color="#115511">'ncstats'</font>)


<font color="#1111cc"># Initialize __kst</font>
__setup_kstat()



<font color="#1111cc"># EOF</font>
</a></pre>
<a name=" ncstats">		  <!--footer-->
		  </a></body></html>