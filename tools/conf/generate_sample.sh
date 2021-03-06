#!/usr/bin/env bash

print_hint() {
    echo "Try \`${0##*/} --help' for more information." >&2
}

PARSED_OPTIONS=$(getopt -n "${0##*/}" -o ho: \
                 --long help,output-dir: -- "$@")

if [ $? != 0 ] ; then print_hint ; exit 1 ; fi

eval set -- "$PARSED_OPTIONS"

while true; do
    case "$1" in
        -h|--help)
            echo "${0##*/} [options]"
            echo ""
            echo "options:"
            echo "-h, --help                show brief help"
            echo "-o, --output-dir=DIR      File output directory"
            exit 0
            ;;
        -o|--output-dir)
            shift
            OUTPUTDIR=`echo $1 | sed -e 's/\/*$//g'`
            shift
            ;;
        --)
            break
            ;;
    esac
done

OUTPUTDIR=${OUTPUTDIR:-etc/cinder}
if ! [ -d $OUTPUTDIR ]
then
    echo "${0##*/}: cannot access \`$OUTPUTDIR': No such file or directory" >&2
    exit 1
fi

OUTPUTFILE=$OUTPUTDIR/cinder.conf.sample
FILES=$(find cinder -type f -name "*.py" ! -path "cinder/tests/*" -exec \
    grep -l "Opt(" {} \; | sort -u)

EXTRA_MODULES_FILE="`dirname $0`/oslo.config.generator.rc"
if test -r "$EXTRA_MODULES_FILE"
then
    source "$EXTRA_MODULES_FILE"
fi

export EVENTLET_NO_GREENDNS=yes

PYTHONPATH=./:${PYTHONPATH} \
    python $(dirname "$0")/../../cinder/openstack/common/config/generator.py ${FILES} > \
    $OUTPUTFILE
