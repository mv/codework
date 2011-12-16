
/bin/mailx -s \
        "Subversion Backup: Repositorio `/bin/date +%Y-%m-%d`" \
        marcus.ferreira@mdb.com.br, marcio.mariani@mdb.com.br  \
<<MAIL

Subversion: Repositório

    Backup retornou um erro inesperado: $ERR

Log de execução:
    _____________________________________________________________

`perl -ne 'printf "    %02d: %s", $., $_' $LOG `
    _____________________________________________________________

MAIL


