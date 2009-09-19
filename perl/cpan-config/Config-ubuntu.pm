
# This is CPAN.pm's systemwide configuration file. This file provides
# defaults for users, and the values can be changed in a per-user
# configuration file. The user-config file is being looked for as
# ~/.cpan/CPAN/MyConfig.pm.

$CPAN::Config = {
  'build_cache'                  => q[900],
  'build_dir'                    => q[/pub/downloads/cpan.org/build],
  'bzip2'                        => q[/bin/bzip2],
  'cache_metadata'               => q[1],
  'cpan_home'                    => q[/pub/downloads/cpan.org],
  'curl'                         => q[/usr/bin/curl],
  'dontload_hash'                => {  },
  'ftp'                          => q[/usr/bin/ftp],
  'ftp_passive'                  => q[1],
  'ftp_proxy'                    => q[http://MDIAS\fsw00030:terra2004@mdbpx.mdb.com.br:8090],
  'getcwd'                       => q[cwd],
  'gpg'                          => q[/usr/bin/gpg],
  'gzip'                         => q[/bin/gzip],
  'histfile'                     => q[/pub/downloads/cpan.org/histfile],
  'histsize'                     => q[500],
  'http_proxy'                   => q[http://MDIAS\fsw00030:terra2004@mdbpx.mdb.com.br:8090],
  'inactivity_timeout'           => q[0],
  'index_expire'                 => q[1],
  'inhibit_startup_message'      => q[0],
  'keep_source_where'            => q[/pub/downloads/cpan.org/sources],
  'lynx'                         => q[],
  'make'                         => q[/usr/bin/make],
  'make_arg'                     => q[],
  'make_install_arg'             => q[],
  'make_install_make_command'    => q[/usr/bin/make],
  'makepl_arg'                   => q[],
  'mbuild_arg'                   => q[],
  'mbuild_install_arg'           => q[],
  'mbuild_install_build_command' => q[./Build],
  'mbuildpl_arg'                 => q[],
  'ncftpget'                     => q[],
  'no_proxy'                     => q[],
  'pager'                        => q[/usr/bin/less],
  'prefer_installer'             => q[EUMM],
  'prerequisites_policy'         => q[follow],
  'scan_cache'                   => q[atstart],
  'shell'                        => q[/bin/bash],
  'show_upload_date'             => q[1],
  'tar'                          => q[/bin/tar],
  'term_is_latin'                => q[1],
  'unzip'                        => q[/usr/bin/unzip],
  'urllist'                      =>  [ q[http://ftp.pucpr.br/CPAN]
                                     , q[ftp://ftp.pucpr.br/CPAN]
                                     , q[http://mirror.uta.edu/CPAN]
                                     , q[http://www.perl.com/CPAN/]
                                     ],
  'wget'                         => q[/usr/bin/wget],
};
1;
__END__
