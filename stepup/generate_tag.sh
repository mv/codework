#!/bin/bash
 
##
# Create tags for commits without notes? Detaults to 0 (false)
TAG_MINOR_COMMITS=0
 
##
# print usage
function usage() {
  cat << EOUSAGE
usage: $0 options
 
 This script contains all logic behind tagging code inside CD's pipeline.
 
OPTIONS:
  -h    Show this message
  -f    Force tagging even minor commits - ie, those commits without any stepup
        note.
EOUSAGE
}
 
# ##
# # Parse command line arguments and set global vars
parse_cmd_args() {
 
  # parse cmd line options
  while getopts ":hf" optname; do
    case "$optname" in
      "h")
        usage
        exit 0
        ;;
      "f")
        TAG_MINOR_COMMITS=1
        echo "Tagging minor commits using vX.Y.Z+DD format"
        ;;
      "?")
        echo "Unknown option $OPTARG"
        usage
        exit 1
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        usage
        exit 1
        ;;
      *)
        echo "Unknown error while processing options"
        usage
        exit 1
        ;;
    esac
  done
}
 
##
# Creates fingerprint file containing the version and revision just created
create_fingerprint() {
  echo "$1" | sed -re 's/^v([\.0-9]+)\+?([0-9]+)?$/version=\1\nrevision=\2/g' > sh/rpm/rpm_version.properties
}
 
parse_cmd_args "$@"
 
# Always try to create a full version with step-up.
# Step-up also take cares of tagging the code accordingly
stepup version create --no-editor
stepup_exit_status=$?
current_version=$(stepup version show)
[[ -z $current_version ]] && echo "Couldn't fetch version number" && exit 1
 
if [ $stepup_exit_status -eq 0 ]; then
  # Cool, step-up created a version. Lets put it in a file for further reference
  create_fingerprint "$current_version" && exit 0
fi
 
echo "Error creating new version with step-up. Maybe we don't have notes !?"
if [ $TAG_MINOR_COMMITS -eq 1 ]; then
  echo "-f flag given - Forcing tag creation"
  git tag $current_version && \
    git push --tags && \
    create_fingerprint "$current_version" && \
    exit 0
  exit 1
fi
 
exit 0
