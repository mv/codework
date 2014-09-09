
## meminfo

    cat /proc/meminfo

## free
    # free --help

    Usage:
     free [options]

    Options:
     -b, --bytes         show output in bytes
     -k, --kilo          show output in kilobytes
     -m, --mega          show output in megabytes
     -g, --giga          show output in gigabytes
         --tera          show output in terabytes
     -h, --human         show human readable output
         --si            use powers of 1000 not 1024
     -l, --lohi          show detailed low and high memory statistics
     -o, --old           use old format (no -/+buffers/cache line)
     -t, --total         show total for RAM + swap
     -s N, --seconds N   repeat printing every N seconds
     -c N, --count N     repeat printing N times

          --help    display this help text
     -V, --version  output version information and exit

    For more details see free(1).

Examples

    $ free -m       # scripting
    $ free -h
                     total       used       free     shared    buffers     cached
        Mem:          995M       928M        66M       1.3M        17M       623M
        -/+ buffers/cache:       288M       707M
        Swap:         511M         8K       511M

    $ free -h -o    # old format
                     total       used       free     shared    buffers     cached
        Mem:          995M       929M        65M       1.3M        17M       623M
        Swap:         511M         8K       511M



## Nagios


    #!/bin/bash
    #
    # Script to check memory usage on Linux. Ignores memory used by disk cache.
    #
    # Requires the bc command
    #
    print_help() {
        echo "Usage:"
        echo "[-w] Warning level as a percentage"
        echo "[-c] Critical level as a percentage"
        exit 0
    }

    while test -n "$1"; do
        case "$1" in
            --help|-h)
                print_help
                exit 0
                ;;
            -w)
                warn_level=$2
                shift
                ;;
            -c)
                critical_level=$2
                shift
                ;;
            *)
                echo "Unknown Argument: $1"
                print_help
                exit 3
                ;;
        esac
        shift
    done

    if [ "$warn_level" == "" ]; then
        echo "No Warning Level Specified"
        print_help
        exit 3;
    fi

    if [ "$critical_level" == "" ]; then
        echo "No Critical Level Specified"
        print_help
        exit 3;
    fi

    free=`free -m | grep "buffers/cache" | awk '{print $4}'`
    used=` free -m | grep "buffers/cache" | awk '{print $3}'`

    total=$(($free+$used))

    result=$(echo "$used / $total * 100" |bc -l|cut -c -2)

    if [ "$result" -lt "$warn_level" ]; then
        echo "Memory OK. $result% used."
        exit 0;
    elif [ "$result" -ge "$warn_level" ] && [ "$result" -le "$critical_level" ]; then
        echo "Memory WARNING. $result% used."
        exit 1;
    elif [ "$result" -gt "$critical_level" ]; then
        echo "Memory CRITICAL. $result% used."
        exit 2;
    fi
