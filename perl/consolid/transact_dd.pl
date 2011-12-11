#!/usr/bin/perl
# $Id: transact_dd.2.pl 746 2006-03-07 15:13:19Z fjunqueira $
# $HeadURL: http://fileserver/svn/netset/trunk/implementation/dba/policard/db/consolid/lib/transact_dd.2.pl $
#
# From: messages   :'2005-06-01 10:00:00' <-> '2005-06-01 xx:xx:xx.yyyyyy'
#   To: transact_hh:'2005-06-01 xx:00:00'
#

package Consolid::Definitions;

sub init_string()
{
    #
    # Consolidation
    my %sql_attr = (
            consolid  => "dd",
            offset_b  => "-3d",
            offset_e  => "+1d",
            trunc     => "dd",
            dt_mask   => "yyyy-mm-dd",
            bind_type => "TIMESTAMP",
    );
    
    my $query = <<'QUERY';
    /* $0: QUERY */
    SELECT dt_trans
         , SUM(qtd)         AS tot_qtd
         , SUM(msg)         AS tot_msg
      FROM transact_dd
     WHERE 1=1
       AND dt_trans BETWEEN $1  -- bind: TIMESTAMP
                        AND $2
  GROUP BY dt_trans
         ;
QUERY

    #
    # Garbage: will ALWAYS fail
    my $ins = <<'INS';
    /* $0: INS */
        INSERT INTO transact_dd ( xxxxABCyyy , created )
             VALUES ( $1, now() );
INS
    #
    # Update: what I REALLY want
    my $upd = <<'UPD';
    /* $0: UPD */
        UPDATE transact_dd
           SET tot_qtd      = $2
             , tot_msg      = $3
             , created      = now()
         WHERE dt_trans     = $1
             ;
UPD
    #
    return ($query,$ins,$upd,%sql_attr);
    #
}

1;
