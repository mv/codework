

# ./a.sh ABRL_AR_EXTRATO_VISA FCP_REQID=63933633 FCP_LOGIN="APPS/APPS" FCP_USERID=61409 FCP_USERNAME="R12_DES" FCP_PRINTER="noprint" FCP_SAVE_OUT=Y FCP_NUM_COPIES=0 "visa.txt" "AR BRASIL_SUPERUSUARIO" "271"
# ./a.sh $parametros

    parametros='ABRL_AR_EXTRATO_VISA FCP_REQID=63933633 FCP_LOGIN="APPS/APPS" FCP_USERID=61409 FCP_USERNAME="R12_DES" FCP_PRINTER="noprint" FCP_SAVE_OUT=Y FCP_NUM_COPIES=0 "visa.txt" "AR BRASIL_SUPERUSUARIO" "271"'

    # separador
    separador() {
        for f in "$@"
        do echo $f
        done | cat -n
    }

    # 10o. parametro, a partir da 2a. coluna
    resp=$( eval separador $parametros | grep 10 | awk '{print $2,$3,$4}' )
    echo $resp


