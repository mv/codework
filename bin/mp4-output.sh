#!/usr/bin/env bash
#
# ferreira.mv
# 2025-05-22
#

usage() {
    echo
    echo "Usage: $0 -f <filename> -d [output_dir]"
    echo
    exit 1
}

[ "${1}" == "" ] && usage

while getopts "f:d:" opt
do
  case $opt in
    f)
      _filename="${OPTARG}"
      ;;
    d)
      _outputdir="${OPTARG}"
      ;;
    *)
      usage
      ;;
  esac
done

# set -x

#
# Remaining arguments
#
shift $((OPTIND - 1))
if [ "${@}x" != "x" ]
then
  echo
  echo "Unknown argument: [${@}]"
  usage
fi

#
# sanity check
#
[ "${_filename}"  == "" ] && usage
[ "${_outputdir}" == "" ] && _outputdir="."

# coreutils: MacOS vs Linux
if which gstat
then _cmd_stat="gstat"
else _cmd_stat="stat"
fi

#
# output file
#
# _birth1=$(stat -x -t '%F'          "${_filename}" | grep Birth | awk -F': ' '{print $2}')
# _birth2=$(stat -x -t '%F %H:%M:%S' "${_filename}" | grep Birth | awk -F': ' '{print $2}')
# _birth_filename=$(${_cmd_stat} "${_filename}" | grep Birth | sed -e 's/ Birth: //' | awk '{print $1}' )
_birth_timestamp=$(${_cmd_stat} "${_filename}" | grep Birth | sed -e 's/ Birth: //' | sed -e 's/[.][0-9]* //' | sed -e 's/ /T/')  #| sed -e 's/[ :]//g' )

# echo "Filename: $_birth_filename"
# echo "Metadata: $_birth_metadata"

_now=$(date '+%Y%m%d%H%M%S')
_birth=$(${_cmd_stat} "${_filename}" | grep Birth | sed -e 's/ Birth: //' | awk '{print $1}' )
_output="${_outputdir}/${_birth}/${_filename%.*}.${_birth}.v${_now}.mp4"

mkdir -p "${_outputdir}/${_birth}"


_echorun() {
  echo
  echo "cmd: [$@]"
  $@
  echo "cmd: [$@]"
  echo
}

#
# Ref:
#   https://trac.ffmpeg.org/wiki/Encode/H.264
#   https://ffmpeg.org/ffmpeg.html
#   https://ffmpeg.org/ffmpeg-utils.html#date-syntax
#
# -crf: constant rate factor: lossless quality. Default 23.
# -preset: speed to compression rate: slower = more quality
# -tune  : change settings according to desired output
#
# range encoding
#    -ss: Offset time from beginning. Value can be in seconds or HH:MM:SS format.
#    -to: Stop writing the output at specified position. Value can be in seconds or HH:MM:SS format.
#     -t: Duration. Value can be in seconds or HH:MM:SS format.
# -sseof: Offset time from end of file. Value can be in seconds or HH:MM:SS format.
#
# all options
#   -formats: show available formats. Included: mp4, aac, ac3, ac4, aiff.
#   -codecs:  show available codecs.  Included: h264, hevc(h265), gif(?), mp4a
#   -c:[stream] codec: select which coded encoder to use.
#      -c:v libx264: video codec: libx264   | -vcodec libx264
#      -c:a libaac : audio codec: aac       | -acodec libaac
#      -c:a copy   : audio codec: keep the same
#      -c:s xxx    : subtitle codec         | -scodec xxx
#   -fs limit_size: output file size in bytes

# ffmpeg -i ${_filename} -c:v libx264          -crf 17 -preset:v veryslow ${_output}.h264.mp4
# ffmpeg -i ${_filename} -crf 17 -c:v libx264           -preset:v veryslow ${_output}.h264.mp4
# ffmpeg -hide_banner -i ${_filename} -crf 17 -preset:v veryslow -tune film -c:v libx264  ${_output}.h264.mp4
# ffmpeg -hide_banner -i ${_filename} -crf 20 -preset:v veryslow -tune film -c:v libx264  ${_output}.h264.mp4
# time ffmpeg -hide_banner -i ${_filename} -preset:v veryslow -tune film -c:v libx264  ${_output}.h264.mp4
# time ffmpeg -hide_banner -benchmark -i ${_filename} -preset:v veryslow -tune film   ${_output}.mp4


# Default: video: H264, audio: mp4a (mpeg AAC)
_echorun time ffmpeg \
    -i ${_filename}  \
    -preset:v veryslow -tune film -metadata Date="${_birth}" -metadata creation_time="${_birth_timestamp}" \
    -hide_banner     \
    ${_output}


# Keep file mtime/atime
[ -f "${_output}" ] && touch -r "${_filename}"  "${_output}"

exit 0
