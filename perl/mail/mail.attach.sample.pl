#!/usr/bin/perl
# $Id: mail.svn.pl 2436 2006-10-28 18:34:16Z marcus.ferreira $
#
#

use Mail::Sender;

my $sender = new Mail::Sender
        { smtp      => 'mdbpx2.mdb.com.br'
        , from      => 'marcus.ferreira@mdb.com.br'
        };

while( <> ) {
    next if /^#/;
    next if /^\s*$/;

    ($user, $pass)=split;
    print "user: $user \n";
    mail( $user, $pass);

};

exit 0;

sub mail {
    my $u = shift;
    my $p = shift;

my $msg=<<MSG;

Caro,

O controle de versão do projeto está no ar. A url de acesso
é http://mdbebsfsw2.mdb.com.br:8080/

Sua senha de acesso ao repositório do projeto foi criada:

    Username: $u
    Password: $p

Essa senha foi criada automaticamente. Há na página de entrada
do projeto um link onde você pode alterá-la.

Para poder usar a ferramenta leia:
    1. svn.usando_projeto_salto.txt
    2. svn.arvore_projeto_salto.txt


Atenciosamente,


Marcus Vinicius Ferreira

MSG

    $sender->MailFile(
            { to        => $u . '@mdb.com.br'
            , cc        => 'marcus.ferreira@mdb.com.br'
            , subject   => 'Sua senha no Subversion.'
            , msg       => $msg
            , file      => '../doc/svn.usando_projeto_salto.txt, ../doc/svn.arvore_projeto_salto.txt'
            , charset   => 'iso-8859-1'
            , b_charset => 'iso-8859-1'
            }
    );

    if( $sender->{'error'} ) {
        print "Error: ", $sender->{'error_msg'},"\n\n";
        exit abs( $sender->{'error'} );
    }
    else {
        print "\n\nMail sent.\n\n";
    };

};
