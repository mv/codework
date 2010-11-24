#-----------------------------------------------------------------------
#  Check number of command line arguments
#-----------------------------------------------------------------------

[ $# -lt 1 ] && { 
    echo -e "\n\tUsage:  ${0##/*/} File\n";
    exit 1
}

[ -z "$1" ] && { 
    echo -e "\n\tUsage:  ${0##/*/} File\n";
    exit 1
}

[ "$1" != "-f" ] && { 
    echo -e "\n\tUsage:  ${0##/*/} -f\n";
    exit 1
}

[ "$1" != "-f" ] && {
    echo
    echo "Usage: $0 -f"
    echo
    echo "    Executa $0 via cron"
    echo
    exit 1
}


