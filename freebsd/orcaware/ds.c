/*
 * Copyright (c) 2006 Zilbo.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */
/*
 * portions of this code were obtained from the FreeBSD iostat/vmstat code 
 * 
 */
/* Copyright (c) 1997, 1998, 2000, 2001  Kenneth D. Merry
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $FreeBSD: src/usr.sbin/iostat/iostat.c,v 1.28 2003/03/15 21:59:06 phk Exp $
 */
/*
 * Parts of this program are derived from the original FreeBSD iostat
 * program:
 */
/*-
 * Copyright (c) 1986, 1991, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
/*
 * Ideas for the new iostat statistics output modes taken from the NetBSD
 * version of iostat:
 */
/*
 * Copyright (c) 1996 John M. Vinopal
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed for the NetBSD Project
 *      by John M. Vinopal.
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
/*
 * Copyright (c) 1980, 1986, 1991, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */



#include <stdio.h>
#include <stdlib.h>
#include <sys/param.h>
#include <sys/errno.h>
#include <sys/resource.h>
#include <sys/sysctl.h>
#include <sys/namei.h>
#include <sys/vmmeter.h>

#include <sys/queue.h>
#include <sys/socket.h>
#include <sys/socketvar.h>
#include <sys/protosw.h>

#include <net/route.h>
#include <netinet/in.h>
#include <netinet/in_systm.h>
#include <netinet/ip.h>
#include <netinet/ip_carp.h>
#include <netinet/in_pcb.h>
#include <netinet/ip_icmp.h>
#include <netinet/icmp_var.h>
#include <netinet/igmp_var.h>
#include <netinet/ip_var.h>
#include <netinet/pim_var.h>
#include <netinet/tcp.h>
#include <netinet/tcpip.h>
#include <netinet/tcp_seq.h>
#include <netinet/tcp_var.h>

#include <netinet/udp.h>
#include <netinet/udp_var.h>
#include <err.h>
#include <ctype.h>
#include <fcntl.h>

#include <nlist.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <devstat.h>
//#include <memstat.h>
#include <math.h>

#define GET_VM_STATS(cat, name) \
	mysysctl("vm.stats." #cat "." #name, &vmmp->name, &size, NULL, 0)

#define	PCT(top, bot) pct((long)(top), (long)(bot))

static struct statinfo cur, last;
static struct vmmeter sum, osum;

static int num_devices;
static struct device_selection *dev_select;
static int maxshowdevs=999;
int sflag =0;

FILE *outfile;
static long
pct(long top, long bot)
{
	long ans;

	if (bot == 0)
		return(0);
	ans = (quad_t)top * 100 / bot;
	return (ans);
}

static int
mysysctl(const char *name, void *oldp, size_t *oldlenp,
    void *newp, size_t newlen)
{
	int error;

	error = sysctlbyname(name, oldp, oldlenp, newp, newlen);
	if (error != 0 && errno != ENOMEM)
		err(1, "sysctl(%s)", name);
	return (error);
}
static long
getuptime(void)
{
	static struct timeval boottime;
	static time_t now;
	time_t uptime;

	if (boottime.tv_sec == 0) {
        size_t size;

        size = sizeof(boottime);
        mysysctl("kern.boottime", &boottime, &size, NULL, 0);
        if (size != sizeof(boottime))
            errx(1, "kern.boottime size mismatch");
	}
	(void)time(&now);
	uptime = now - boottime.tv_sec;
	if (uptime <= 0 || uptime > 60*60*24*365*10)
		errx(1, "time makes no sense; namelist must be wrong");
	return(uptime);
}

static void
fill_vmmeter(struct vmmeter *vmmp)
{
    size_t size = sizeof(unsigned int);
    /* sys */
    GET_VM_STATS(sys, v_swtch);
    GET_VM_STATS(sys, v_trap);
    GET_VM_STATS(sys, v_syscall);
    GET_VM_STATS(sys, v_intr);
    GET_VM_STATS(sys, v_soft);

    /* vm */
    GET_VM_STATS(vm, v_vm_faults);
    GET_VM_STATS(vm, v_cow_faults);
    GET_VM_STATS(vm, v_cow_optim);
    GET_VM_STATS(vm, v_zfod);
    GET_VM_STATS(vm, v_ozfod);
    GET_VM_STATS(vm, v_swapin);
    GET_VM_STATS(vm, v_swapout);
    GET_VM_STATS(vm, v_swappgsin);
    GET_VM_STATS(vm, v_swappgsout);
    GET_VM_STATS(vm, v_vnodein);
    GET_VM_STATS(vm, v_vnodeout);
    GET_VM_STATS(vm, v_vnodepgsin);
    GET_VM_STATS(vm, v_vnodepgsout);
    GET_VM_STATS(vm, v_intrans);
    GET_VM_STATS(vm, v_reactivated);
    GET_VM_STATS(vm, v_pdwakeups);
    GET_VM_STATS(vm, v_pdpages);
    GET_VM_STATS(vm, v_dfree);
    GET_VM_STATS(vm, v_pfree);
    GET_VM_STATS(vm, v_tfree);
    GET_VM_STATS(vm, v_page_size);
    GET_VM_STATS(vm, v_page_count);
    GET_VM_STATS(vm, v_free_reserved);
    GET_VM_STATS(vm, v_free_target);
    GET_VM_STATS(vm, v_free_min);
    GET_VM_STATS(vm, v_free_count);
    GET_VM_STATS(vm, v_wire_count);
    GET_VM_STATS(vm, v_active_count);
    GET_VM_STATS(vm, v_inactive_target);
    GET_VM_STATS(vm, v_inactive_count);
    GET_VM_STATS(vm, v_cache_count);
    GET_VM_STATS(vm, v_cache_min);
    GET_VM_STATS(vm, v_cache_max);
    GET_VM_STATS(vm, v_pageout_free_min);
    GET_VM_STATS(vm, v_interrupt_free_min);
    /*GET_VM_STATS(vm, v_free_severe);*/
    GET_VM_STATS(vm, v_forks);
    GET_VM_STATS(vm, v_vforks);
    GET_VM_STATS(vm, v_rforks);
    GET_VM_STATS(vm, v_kthreads);
    GET_VM_STATS(vm, v_forkpages);
    GET_VM_STATS(vm, v_vforkpages);
    GET_VM_STATS(vm, v_rforkpages);
    GET_VM_STATS(vm, v_kthreadpages);
}

static void
fill_vmtotal(struct vmtotal *vmtp)
{
    size_t size = sizeof(*vmtp);
    mysysctl("vm.vmtotal", vmtp, &size, NULL, 0);
    if (size != sizeof(*vmtp))
        errx(1, "vm.total size mismatch");
}

static void
dointr(void)
{
	unsigned long *intrcnt, uptime, *pintrcnt;
	uint64_t inttotal;
	size_t clen, inamlen, intrcntlen, istrnamlen;
	unsigned int i, nintr;
	char *intrname, *tintrname, *pintrname;

	uptime = getuptime();
    for (intrcnt = NULL, intrcntlen = 1024; ; intrcntlen *= 2) {
        if ((intrcnt = reallocf(intrcnt, intrcntlen)) == NULL)
            err(1, "reallocf()");
        if (mysysctl("hw.intrcnt",
            intrcnt, &intrcntlen, NULL, 0) == 0)
            break;
    }
    pintrcnt = intrcnt;
    for (intrname = NULL, inamlen = 1024; ; inamlen *= 2) {
        if ((intrname = reallocf(intrname, inamlen)) == NULL)
            err(1, "reallocf()");
        if (mysysctl("hw.intrnames",
            intrname, &inamlen, NULL, 0) == 0)
            break;
    }

    pintrname = intrname;
	nintr = intrcntlen / sizeof(unsigned long);
	tintrname = intrname;
	istrnamlen = strlen("interrupt");
	for (i = 0; i < nintr; i++) {
		clen = strlen(tintrname);
		if (clen > istrnamlen)
			istrnamlen = clen;
		tintrname += clen + 1;
	}

	(void)fprintf(outfile,"<interrupts total='%llu' rate='%llu'>\n", (long long)inttotal, (long long)(inttotal / uptime));
//	printf("%-*s %20s %10s\n", istrnamlen, "interrupt", "total", "rate");
	inttotal = 0;
	for (i = 0; i < nintr; i++) {
		if (intrname[0] != '\0' && (*intrcnt != 0 )) {
			fprintf(outfile, "\t<stat name='interrupt_%s' value='%lu' />", intrname, *intrcnt );
            if (uptime >0) {
                fprintf( outfile, "\t<stat name='interrupt_rate_%s'  value='%lu' />\n",  intrname, *intrcnt / uptime);
            }
        }
		intrname += strlen(intrname) + 1;
		inttotal += *intrcnt++;
	}
    free( pintrcnt );
    free( pintrname );
    fprintf(outfile,"</interrupts>\n");
}


void printstat(char*name, char*desc, long total )
{
    fprintf(outfile,"\t<stat name='%s' desc='%s' value='%u' />\n", name, desc, total );
}
static void
dosum(void)
{
	struct nchstats lnchstats;
	long nchtotal;

    fprintf(outfile,"<vmstat>\n");
    printstat( "swtch", "cpu context switches", sum.v_swtch );
    printstat( "intr", "device interrupts", sum.v_intr);
    printstat( "soft", "software interrupts", sum.v_soft);
    printstat( "trap", "traps", sum.v_trap);
    printstat( "syscall", "system calls", sum.v_syscall);
    printstat( "k_threads", "kernel threads created", sum.v_kthreads);
	
    /*
	(void)fprintf(outfile,"%9u  fork() calls\n", sum.v_forks);
	(void)printf("%9u vfork() calls\n", sum.v_vforks);
	(void)printf("%9u rfork() calls\n", sum.v_rforks);
    */
    printstat( "swapin", "swap pager pageins", sum.v_swapin);
    printstat( "swappgsin", "swap pager pages paged ins", sum.v_swappgsin );
    printstat( "swapout", "swap pager pageouts", sum.v_swapout);
    printstat( "swappgsout", "swap pager pages paged out", sum.v_swappgsout);
    printstat( "vnodein", "vnode pager pageins", sum.v_vnodein);
    printstat( "vnodepgsin", "vnode pager pages paged in", sum.v_vnodepgsin);
    printstat( "vnodeout", "vnode pager pageouts", sum.v_vnodeout);
    printstat( "vnodepgsout", "vnode pager pages paged out", sum.v_vnodepgsout);
    printstat( "pdwakeups", "page daemon wakeups", sum.v_pdwakeups);
    printstat( "pdpages", "pages examined by the page daemon", sum.v_pdpages);
    printstat( "reactivated", "pages reactivated", sum.v_reactivated);
    printstat( "cow_faults", "copy-on-write faults", sum.v_cow_faults);
    printstat( "cow_optim", "copy-on-write optimized faults", sum.v_cow_optim);
    printstat( "zfod", "zero fill pages zeroed", sum.v_zfod);
    printstat( "ozfod", "zero fill pages prezeroed", sum.v_ozfod);
    printstat( "intrans", "intransit blocking page faults", sum.v_intrans);
    printstat( "vm_faults", "total VM faults taken", sum.v_vm_faults);
    printstat( "kthreadpages", "pages affected by kernel thread creation", sum.v_kthreadpages);
    /*
	(void)printf("%9u pages affected by  fork()\n", sum.v_forkpages);
	(void)printf("%9u pages affected by vfork()\n", sum.v_vforkpages);
	(void)printf("%9u pages affected by rfork()\n", sum.v_rforkpages);
    */
    printstat( "tfree", "pages freed", sum.v_tfree);
    printstat( "dfree", "pages freed by daemon", sum.v_dfree);
    printstat( "pfree", "pages freed by exiting processes", sum.v_pfree);
    printstat( "active_count", "pages active", sum.v_active_count);
    printstat( "inactive_count", "pages inactive", sum.v_inactive_count);
    printstat( "cache_count", "pages in VM cache", sum.v_cache_count);
    printstat( "wire_count", "pages wired down", sum.v_wire_count);
    printstat( "free_count", "pages free", sum.v_free_count);
    printstat( "page_size", "bytes per page", sum.v_page_size);

    fprintf(outfile, "</vmstat>\n");
    fprintf(outfile, "<vfsstat>\n");
    size_t size = sizeof(lnchstats);
    mysysctl("vfs.cache.nchstats", &lnchstats, &size, NULL, 0);
    if (size != sizeof(lnchstats))
        errx(1, "vfs.cache.nchstats size mismatch");

	nchtotal = lnchstats.ncs_goodhits + lnchstats.ncs_neghits +
	    lnchstats.ncs_badhits + lnchstats.ncs_falsehits +
	    lnchstats.ncs_miss + lnchstats.ncs_long;
    printstat( "nchtotal", "total name lookups", nchtotal);
    printstat( "ncs_goodhits", "cache pos hits", lnchstats.ncs_goodhits);
    printstat( "ncs_goodhits%", "cache pos hits% ", PCT(lnchstats.ncs_goodhits, nchtotal));
    printstat( "ncs_neghits", "cache neg hits", lnchstats.ncs_neghits);
    printstat( "ncs_neghits%", "cache neg hits% ", PCT(lnchstats.ncs_neghits, nchtotal));
    printstat( "ncs_pass2", "cache hits per-directory", lnchstats.ncs_pass2);
    printstat( "ncs_pass2%", "cache hits per-directory%", PCT(lnchstats.ncs_pass2, nchtotal));

    printstat( "ncs_badhits", "cache deletions", lnchstats.ncs_badhits);
    printstat( "ncs_badhits%", "cache deletions%", PCT(lnchstats.ncs_badhits, nchtotal));

    printstat( "ncs_falsehits", "cache falsehits ", lnchstats.ncs_falsehits);
    printstat( "ncs_falsehits%", "cache falsehits %", PCT(lnchstats.ncs_falsehits, nchtotal));

    printstat( "ncs_long", "cache toolong", lnchstats.ncs_long);
    printstat( "ncs_long%", "cache toolong %", PCT(lnchstats.ncs_long, nchtotal));
    fprintf(outfile,"</vfsstat>\n");
}


static void
doforkst(void)
{
    fprintf(outfile,"<forkstat>\n");
	fprintf(outfile,"\t<stat name='forks' value='%u' pages='%u' average='%.2f' />\n",
	    sum.v_forks, sum.v_forkpages,
	    sum.v_forks == 0 ? 0.0 :
	    (double)sum.v_forkpages / sum.v_forks);
	fprintf(outfile,"\t<stat name='vforks' value='%u' pages='%u' average='%.2f' />\n",
	    sum.v_vforks, sum.v_vforkpages,
	    sum.v_vforks == 0 ? 0.0 :
	    (double)sum.v_vforkpages / sum.v_vforks);
	fprintf(outfile,"\t<stat name='rforks' value='%u' pages='%u' average='%.2f' />\n",
	    sum.v_rforks, sum.v_rforkpages,
	    sum.v_rforks == 0 ? 0.0 :
	    (double)sum.v_rforkpages / sum.v_rforks);
    fprintf(outfile,"</forkstat>\n");
}




static void
cpustats(void)
{
	register int state;
	double time;

	time = 0.0;

    char *labels[] = { "usr", "nice", "sys", "interupt", "idle" };
    fprintf(outfile, "<cpu>\n");
	for (state = 0; state < CPUSTATES; ++state) {
		time += cur.cp_time[state];
    }

	for (state = 0; state < CPUSTATES; ++state)
		fprintf(outfile, "\t<stat name='%s' value='%f' time='%ld'/>\n", 
                 labels[state], 
                 100.0 * cur.cp_time[state] / (time ? time : 1), 
                 cur.cp_time[state] );

    fprintf(outfile, "</cpu>\n");
}

static void
devstats(int perf_select, long double etime, int havelast)
{
	register int dn;
	long double transfers_per_second;
	long double kb_per_transfer, mb_per_second;
	u_int64_t total_bytes, total_transfers, total_blocks;
	long double total_mb;
	long double blocks_per_second, ms_per_transaction;
	long double busy_pct;
    u_int64_t queue_length; 

    if (havelast == 1 ) {
        fprintf(outfile,"<devices>\n");
    }
	for (dn = 0; dn < num_devices; dn++) {
		int di;

		if (((perf_select == 0) && (dev_select[dn].selected == 0))
		 || (dev_select[dn].selected > maxshowdevs))
			continue;

		di = dev_select[dn].position;

		if (devstat_compute_statistics(&cur.dinfo->devices[di],
		    havelast ? &last.dinfo->devices[di] : NULL, etime,
		    DSM_TOTAL_BYTES, &total_bytes,
		    DSM_TOTAL_TRANSFERS, &total_transfers,
		    DSM_TOTAL_BLOCKS, &total_blocks,
		    DSM_KB_PER_TRANSFER, &kb_per_transfer,
		    DSM_TRANSFERS_PER_SECOND, &transfers_per_second,
		    DSM_MB_PER_SECOND, &mb_per_second, 
		    DSM_BLOCKS_PER_SECOND, &blocks_per_second,
		    DSM_MS_PER_TRANSACTION, &ms_per_transaction,
		    DSM_BUSY_PCT, &busy_pct,
		    DSM_QUEUE_LENGTH, &queue_length,
		    DSM_NONE) != 0)
			errx(1, "%s", devstat_errbuf);

		if (perf_select != 0) {
			dev_select[dn].bytes = total_bytes;
			if ((dev_select[dn].selected == 0)
			 || (dev_select[dn].selected > maxshowdevs))
				continue;
		}

        /* skip since boot figures */
        if ( havelast == 1 )  {
            fprintf(outfile, "\t<device name='%s'  unit='%d'>\n", cur.dinfo->devices[di].device_name, cur.dinfo->devices[di].unit_number);
            fprintf(outfile,"		<stat name='total_bytes' value='%qu' />\n", total_bytes);
            fprintf(outfile,"		<stat name='total_transfers' value='%qu' />\n", total_transfers);
            fprintf(outfile,"		<stat name='total_blocks' value='%qu' />\n", total_blocks);
            fprintf(outfile,"		<stat name='kb_per_transfer' value='%Lf' />\n", kb_per_transfer );
            fprintf(outfile,"		<stat name='transfers_per_second' value='%Lf' />\n", transfers_per_second);
            fprintf(outfile,"		<stat name='mb_per_second' value='%Lf' />\n", mb_per_second);
            fprintf(outfile,"		<stat name='blocks_per_second' value='%Lf' />\n", blocks_per_second);
            fprintf(outfile,"		<stat name='ms_per_transaction' value='%Lf' />\n", ms_per_transaction);
            fprintf(outfile,"		<stat name='busy_pct' value='%Lf' />\n", busy_pct);
            fprintf(outfile,"		<stat name='queue_length' value='%qu' />\n", queue_length);
            fprintf(outfile,"\t</device>\n");
        }
   }
   if ( havelast == 1 ) {
        fprintf(outfile,"</devices>\n");
   }
}

static int
readvar( const char *name, void *ptr, size_t len)
{
    size_t nlen = len;

    if (sysctlbyname(name, ptr, &nlen, NULL, 0) == -1) {
        warn("sysctl(%s...) failed", name);
        return (1);
    }
    if (nlen != len) {
        warnx("sysctl(%s...): expected %lu, got %lu", name,
              (unsigned long)len, (unsigned long)nlen);
        return (1);
    }

	return (0);
}
const char *
plural(int n)
{
	return (n != 1 ? "s" : "");
}

/*
 * Dump IP statistics structure.
 */
void
ip_stats( void )
{
	struct ipstat ipstat, zerostat;
	size_t len = sizeof ipstat;

	if (sysctlbyname("net.inet.ip.stats", &ipstat, &len, NULL, 0) < 0) {
		warn("sysctl: net.inet.ip.stats");
		return;
	}
    fprintf(outfile,"<ip>\n");

    printstat( "ips_total", "total packets received", ipstat.ips_total );
    printstat( "ips_badsum", "bad header checksum", ipstat.ips_badsum );
    printstat( "ips_toosmall", "size smaller than minimum", ipstat.ips_toosmall );
    printstat( "ips_tooshort", "data size less than data length", ipstat.ips_tooshort);
    printstat( "ips_toolong", "ip length greater max ip packet size", ipstat.ips_toolong);
    printstat( "ips_badhlen", "header length less than data size", ipstat.ips_badhlen);
    printstat( "ips_badlen", "data length less than header length", ipstat.ips_badlen);
    printstat( "ips_badoptions", "bad options", ipstat.ips_badoptions);
    printstat( "ips_badvers", "incorrect version number", ipstat.ips_badvers);
    printstat( "ips_fragments", "fragments received", ipstat.ips_fragments);
    printstat( "ips_fragdropped", "fragments dropped (dup or out of space)", ipstat.ips_fragdropped);
    printstat( "ips_fragtimeout", "fragments dropped after timeout", ipstat.ips_fragtimeout);
    printstat( "ips_reassembled", "packets reassembled ok", ipstat.ips_reassembled);
    printstat( "ips_delivered", "packets for this host", ipstat.ips_delivered);
    printstat( "ips_noproto", "packets for unknown/unsupported protocol", ipstat.ips_noproto);
    printstat( "ips_forward", "packets forwarded", ipstat.ips_forward);
    printstat( "ips_fastforward", "packets fast forwarded", ipstat.ips_fastforward);
    printstat( "ips_cantforward", "packets not forwardable", ipstat.ips_cantforward);
    printstat( "ips_notmember", "packets received for unknown multicast group", ipstat.ips_notmember);
    printstat( "ips_redirectsent", "redirects sent", ipstat.ips_redirectsent);
    printstat( "ips_localout", "packets sent from this host", ipstat.ips_localout );
    printstat( "ips_rawout", "packets sent from with fabricated ip header", ipstat.ips_rawout );
    printstat( "ips_odropped", "output packets dropped due to no bufs, etc", ipstat.ips_odropped);
    printstat( "ips_noroute", "output packets discarded due to no route", ipstat.ips_noroute);
    printstat( "ips_fragmented", "output datagrams fragmented", ipstat.ips_fragmented);
    printstat( "ips_ofragments", "fragments created", ipstat.ips_ofragments);
    printstat( "ips_cantfrag", "datagrams that can not be fragmented", ipstat.ips_cantfrag);
    printstat( "ips_nogif", "tunneling packets that can not find gif", ipstat.ips_nogif);
    printstat( "ips_badaddr", "datagrams with bad address in header", ipstat.ips_badaddr);

    fprintf(outfile,"</ip>\n");
}

/*
 * Dump TCP statistics structure.
 */
void
tcp_stats( void)
{
	struct tcpstat tcpstat, zerostat;
	size_t len = sizeof tcpstat;
	
	if (sysctlbyname("net.inet.tcp.stats", &tcpstat, &len,
	    NULL, 0) < 0) {
		warn("sysctl: net.inet.tcp.stats");
		return;
	}

    fprintf( outfile, "<tcp>\n" );
	
    printstat( "tcps_sndtotal", "packets sent", tcpstat.tcps_sndtotal );
    printstat( "tcps_sndpack", "data packets sent", tcpstat.tcps_sndpack );
    printstat( "tcps_sndbyte", "data bytes sent", tcpstat.tcps_sndbyte );
    printstat( "tcps_sndrexmitpack", "data packets retransmitted", tcpstat.tcps_sndrexmitpack);
    printstat( "tcps_sndrexmitbyte", "data bytes retransmitted", tcpstat.tcps_sndrexmitbyte);
    printstat( "tcps_sndrexmitbad", "data packets retransmitted unnecessarily ", tcpstat.tcps_sndrexmitbad);
    printstat( "tcps_mturesent", "resend initiated by MTU descovery", tcpstat.tcps_mturesent );
    printstat( "tcps_sndacks", "ack-only packets", tcpstat.tcps_sndacks);
    printstat( "tcps_delack", "ack-only packets delayed", tcpstat.tcps_delack);
    printstat( "tcps_sndurg", "URG only packets", tcpstat.tcps_sndurg);
    printstat( "tcps_sndprobe", "window probe packets", tcpstat.tcps_sndprobe);
    printstat( "tcps_sndwinup", "window update packets", tcpstat.tcps_sndwinup);
    printstat( "tcps_sndctrl", "control packets", tcpstat.tcps_sndctrl);
    printstat( "tcps_rcvtotal", "packets received", tcpstat.tcps_rcvtotal);
    printstat( "tcps_rcvackpack", "acks", tcpstat.tcps_rcvackpack);
    printstat( "tcps_rcvackbyte", "ack bytes", tcpstat.tcps_rcvackbyte);
    printstat( "tcps_rcvdupack", "dup acks", tcpstat.tcps_rcvdupack);
    printstat( "tcps_rcvacktoomuch", "acks for unsent data", tcpstat.tcps_rcvacktoomuch);
    printstat( "tcps_rcvpack", "packets received in-sequence", tcpstat.tcps_rcvpack);
    printstat( "tcps_rcvbyte", "bytes received in-sequence", tcpstat.tcps_rcvbyte);
    printstat( "tcps_rcvduppack", "completely duplicate packets", tcpstat.tcps_rcvduppack);
    printstat( "tcps_rcvdupbyte", "completely duplicate bytes", tcpstat.tcps_rcvdupbyte);
    printstat( "tcps_pawsdrop", "old duplicate packets", tcpstat.tcps_pawsdrop);

    printstat( "tcps_rcvpartduppack", "packets with some dup. data", tcpstat.tcps_rcvpartduppack);
    printstat( "tcps_rcvpartdupbyte", "bytes with some dup. data", tcpstat.tcps_rcvpartdupbyte);
    printstat( "tcps_rcvoopack", "out-of-order packets", tcpstat.tcps_rcvoopack);
    printstat( "tcps_rcvoobyte", "out-of-order bytes", tcpstat.tcps_rcvoobyte);
    printstat( "tcps_rcvpackafterwin", "packets of data after window", tcpstat.tcps_rcvpackafterwin);
    printstat( "tcps_rcvbyteafterwin", "bytes of data after window", tcpstat.tcps_rcvbyteafterwin);
    printstat( "tcps_rcvwinprobe", "window probe", tcpstat.tcps_rcvwinprobe );
    printstat( "tcps_rcvwinupd", "window update probe", tcpstat.tcps_rcvwinupd);
    printstat( "tcps_rcvafterclose", "packets received after close", tcpstat.tcps_rcvafterclose );
    printstat( "tcps_rcvbadsum", "discarded for bad checksum", tcpstat.tcps_rcvbadsum);
    printstat( "tcps_rcvbadoff", "discarded for bad header offset fields", tcpstat.tcps_rcvbadoff);
    printstat( "tcps_rcvshort", "discarded because packet too short", tcpstat.tcps_rcvshort );
    printstat( "tcps_connattempt", "connection requests", tcpstat.tcps_connattempt );
    printstat( "tcps_accepts", "connection accepts", tcpstat.tcps_accepts );
    printstat( "tcps_badsyn", "bad connection accepts", tcpstat.tcps_badsyn);
    printstat( "tcps_listendrop", "listen queue overflows", tcpstat.tcps_listendrop );
    printstat( "tcps_badrst", "ignored RSTs in the window", tcpstat.tcps_badrst );
    printstat( "tcps_connects", "connections established (including accepts)", tcpstat.tcps_connects);

    printstat( "tcps_closed", "connections closed (including drops)", tcpstat.tcps_closed);
    printstat( "tcps_drops", "connections drops", tcpstat.tcps_drops);

    printstat( "tcps_cachedrtt", "connections updated cached RTT on close", tcpstat.tcps_cachedrtt);
    printstat( "tcps_cachedrttvar", "updated cached RTT variance on close", tcpstat.tcps_cachedrttvar);
    printstat( "tcps_cachedssthresh", "connections updated cached ssthresh on close", tcpstat.tcps_cachedssthresh );
    printstat( "tcps_conndrops", "embryonic connections dropped ", tcpstat.tcps_conndrops );
    printstat( "tcps_rttupdated", "segments updated rtt ", tcpstat.tcps_rttupdated );
    printstat( "tcps_segstimed", "segments updated rtt attempts", tcpstat.tcps_segstimed );

    printstat( "tcps_rexmttimeo", "retransmit timeouts", tcpstat.tcps_rexmttimeo );
    printstat( "tcps_timeoutdrop", "connections droped by rexmit timeout", tcpstat.tcps_timeoutdrop );
    printstat( "tcps_persisttimeo", "persist timeout", tcpstat.tcps_persisttimeo );
    printstat( "tcps_persistdrop", "connections dropped by persist timeout", tcpstat.tcps_persistdrop );
    printstat( "tcps_keeptimeo", "keepalive timeout", tcpstat.tcps_keeptimeo);
    printstat( "tcps_keepprobe", "keepalive probes sent", tcpstat.tcps_keepprobe);
    printstat( "tcps_keepdrops", "connections dropped by keepalive", tcpstat.tcps_keepdrops);

    printstat( "tcps_predack", "correct ACK header predictions", tcpstat.tcps_predack);
    printstat( "tcps_preddat", "correct data packet header predictions", tcpstat.tcps_preddat);

    printstat( "tcps_sc_added", "syncache entries added", tcpstat.tcps_sc_added);
    printstat( "tcps_sc_retransmitted", "syncache retransmitted", tcpstat.tcps_sc_retransmitted);
    printstat( "tcps_sc_dupsyn", "syncache dupsyn", tcpstat.tcps_sc_dupsyn);
    printstat( "tcps_sc_dropped", "syncache dropped", tcpstat.tcps_sc_dropped);
    printstat( "tcps_sc_completed", "syncache completed", tcpstat.tcps_sc_completed);
    printstat( "tcps_sc_bucketoverflow", "syncache bucket overflow", tcpstat.tcps_sc_bucketoverflow);
    printstat( "tcps_sc_cacheoverflow", "syncache cache overflow", tcpstat.tcps_sc_cacheoverflow);
    printstat( "tcps_sc_reset", "syncache reset", tcpstat.tcps_sc_reset);
    printstat( "tcps_sc_stale", "syncache stale", tcpstat.tcps_sc_stale);
    printstat( "tcps_sc_aborted", "syncache aborted", tcpstat.tcps_sc_aborted);
    printstat( "tcps_sc_badack", "syncache backack", tcpstat.tcps_sc_badack);
    printstat( "tcps_sc_unreach", "syncache unreach", tcpstat.tcps_sc_unreach);

    printstat( "tcps_sc_zonefail", "syncache zone failure", tcpstat.tcps_sc_zonefail);
    printstat( "tcps_sc_sendcookie", "syncache cookies sent", tcpstat.tcps_sc_sendcookie);
    printstat( "tcps_sc_recvcookie", "syncache cookies received", tcpstat.tcps_sc_recvcookie);

    printstat( "tcps_sack_recovery_episode", "SACK recovery episodes", tcpstat.tcps_sack_recovery_episode);
    printstat( "tcps_sack_rexmits", "segment rexmits SACK recovery episodes", tcpstat.tcps_sack_rexmits );
    printstat( "tcps_sack_rexmit_bytes", "bytes rexmits SACK recovery episodes", tcpstat.tcps_sack_rexmit_bytes );
    printstat( "tcps_sack_rcv_blocks", "SACK options (SACK blocks) received", tcpstat.tcps_sack_rcv_blocks );
    printstat( "tcps_sack_send_blocks", "SACK options (SACK blocks) sent", tcpstat.tcps_sack_send_blocks );

//	p1a(tcps_sack_sboverflow, "\t%lu SACK scoreboard overflow\n"); 

    fprintf( outfile, "</tcp>\n" );
}

/*
 * Dump UDP statistics structure.
 */
void
udp_stats(void)
{
	struct udpstat udpstat, zerostat;
	size_t len = sizeof udpstat;
	u_long delivered;

	if (sysctlbyname("net.inet.udp.stats", &udpstat, &len, NULL, 0 ) < 0) {
		warn("sysctl: net.inet.udp.stats");
		return;
	}

    fprintf( outfile, "<udp>\n" );
	
    printstat( "udps_ipackets", "datagrams received", udpstat.udps_ipackets);
    printstat( "udps_hdrops", "incomplete header", udpstat.udps_hdrops);
    printstat( "udps_badlen", "bad data length field", udpstat.udps_badlen);
    printstat( "udps_badsum", "bad checksum", udpstat.udps_badsum);
    printstat( "udps_nosum", "no checksum", udpstat.udps_nosum);
    printstat( "udps_noport", "dropped due to no socket", udpstat.udps_noport);
    printstat( "udps_noportbcast", "broadcast/multicast dropped due to no socket", udpstat.udps_noportbcast);
    printstat( "udps_fullsock", "dropped due to full socket buffers", udpstat.udps_fullsock);
    printstat( "udpps_pcbhashmiss", "not for hashed pcb", udpstat.udpps_pcbhashmiss);
	
	delivered = udpstat.udps_ipackets -
		    udpstat.udps_hdrops -
		    udpstat.udps_badlen -
		    udpstat.udps_badsum -
		    udpstat.udps_noport -
		    udpstat.udps_noportbcast -
		    udpstat.udps_fullsock;

    printstat( "delivered", "delivered", delivered);
    printstat( "udps_opackets", "datagrams output", udpstat.udps_opackets);

    fprintf( outfile, "</udp>\n" );
}



main()
{
	long generation;
	struct vmtotal total;
	devstat_select_mode select_mode;
	int num_devices_specified=0;
	int num_selected = 0; 
    int num_selections = 0;
	long select_generation;
	int num_matches = 0;
	struct devstat_match *matches;
	char **specified_devices = NULL;
    int hflag=0;
    int waittime = 300; /* should be 300 seconds - 5 minutes*/
    char *prefix="/var/tmp/zilbo/bsd_allator.";
    char *filename;
    time_t snapshot_time;
//    int debug=5;

    fclose(stdin);
    fclose(stdout);
	if (devstat_checkversion(NULL) < 0)
		errx(1, "%s", devstat_errbuf);

        /* find out how many devices we have */
    if ((num_devices = devstat_getnumdevs(NULL)) < 0) {
        err(1, "can't get number of devices");
        }
	
    cur.dinfo = (struct devinfo *)malloc(sizeof(struct devinfo));
    if (cur.dinfo == NULL) {
        err(1, "malloc failed");
    }

    last.dinfo = (struct devinfo *)malloc(sizeof(struct devinfo));
    if (last.dinfo == NULL) {
        err(1, "malloc failed");
    }

    bzero(cur.dinfo, sizeof(struct devinfo));
    bzero(last.dinfo, sizeof(struct devinfo));

    /* get the device list */

    if (devstat_getdevs(NULL, &cur) == -1)
        errx(1, "%s", devstat_errbuf);

    num_devices = cur.dinfo->numdevs;
    generation = cur.dinfo->generation;
    select_mode = DS_SELECT_ADD;
    dev_select = NULL;
    matches = NULL;
	int havelast = 0;

	specified_devices = (char **)malloc(sizeof(char *));
	if (specified_devices == NULL)
		err(1, "malloc failed");


	if (devstat_selectdevs(&dev_select, &num_selected, &num_selections, 
                    &select_generation, generation,
			       cur.dinfo->devices, num_devices, 
                   matches, num_matches, 
                   specified_devices, num_devices_specified, select_mode, maxshowdevs, hflag) == -1) {
		errx(1, "%s", devstat_errbuf);
    }

	bzero(&cur.cp_time, sizeof(cur.cp_time));
	cur.tk_nout = 0;
	cur.tk_nin = 0;
	cur.snap_time = 0;

    /* $prefix.<10digits>.xml" */
    filename = malloc ( strlen( prefix ) + 15 );    

    while ( 1 )  {
    //while ( --debug )  {
        int i;
        struct devinfo *tmp_dinfo;
        long tmp;
        long double etime;
        tmp_dinfo = last.dinfo;
        last.dinfo = cur.dinfo;
        cur.dinfo = tmp_dinfo;

        last.snap_time = cur.snap_time;

        snapshot_time = time(NULL);
        sprintf( filename, "%s%ld.xml", prefix, snapshot_time );
        readvar( "kern.cp_time", &cur.cp_time, sizeof(cur.cp_time)) ;
        /* 1 == device list has changed */
		switch (devstat_getdevs(NULL, &cur)) {
            case -1:
                errx(1, "%s", devstat_errbuf);
                break;
            case 1: {
                int retval;

                num_devices = cur.dinfo->numdevs;
                generation = cur.dinfo->generation;
                retval = devstat_selectdevs(&dev_select, &num_selected, &num_selections,
                                &select_generation, generation,
                                cur.dinfo->devices, num_devices, 
                                matches, num_matches,
                                specified_devices, num_devices_specified,
                                select_mode, maxshowdevs, hflag);
                if (retval == -1 ) {
                    errx(1, "%s", devstat_errbuf);
                    break;
                }
            }
            default:
                break;
		}
		etime = cur.snap_time - last.snap_time;

        if (etime == 0.0)
			etime = 1.0;

		for (i = 0; i < CPUSTATES; i++) {
			tmp = cur.cp_time[i];
			cur.cp_time[i] -= last.cp_time[i];
			last.cp_time[i] = tmp;
		}

        if ( havelast == 1 ) {
            outfile = fopen( filename, "w");
            fprintf(outfile, "<snapshot time='%ld'>\n", snapshot_time );
        }
		devstats(hflag, etime, havelast);


        if (havelast ==1 ) {
            cpustats();
        }

        fill_vmmeter(&sum);
		fill_vmtotal(&total);


        if ( havelast == 1 ) {
            fprintf( outfile, "<vm>\n" );
            doforkst();
            dosum();
            dointr();
            fprintf( outfile, "</vm>\n" );

            tcp_stats();

            udp_stats();

            ip_stats();

            fprintf(outfile,"</snapshot>\n");
            fclose(outfile);
            outfile=NULL;
        }
        havelast = 1;

        sleep(waittime);
    }

    if (outfile)
        fclose(outfile);
    fprintf (stderr, "term");
    return 0;
}
