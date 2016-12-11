#!/usr/local/bin/bash

function dateComp()
{
    ARG1_SECOND=$1
    ARG2_SECOND=$2

    expr $ARG1_SECOND - $ARG2_SECOND
}

BASEDIR="/home/taichiwbb/tmp/Eagles"
TMP_PITCHER_FILE="${BASEDIR}/tmp_p.tmp"

grep ',投,'  /home/taichiwbb/tmp/Eagles/*.dat | grep -v '相手,投,' | sed -e 's/\(.*\)_\(.*\)01_\(.*\),\(.*\),\(.*\),\(.*\),\(.*\)/\2 \5/g' > ${TMP_PITCHER_FILE}

function tmpFileName() {
    echo ${BASEDIR}/`printf "%.2d" ${1}`_pitcher.dat
}

function outPictherDataFile() {
    OPENING_DAY=20160325
    TODAY=`date +%Y%m%d`

    DATE=${OPENING_DAY}
    REQ=`dateComp $DATE $TODAY`

    WEEK=1
    DAY_OF_WEEK=1

    TMPFILE=`tmpFileName ${WEEK}`
    cat /dev/null > ${TMPFILE}
    while [ ${REQ} -lt 0 ]
    do
        PITCHER=`grep ${DATE} ${TMP_PITCHER_FILE}`
        if [ ! $? -eq 0 ]; then
            PITCHER="${DATE} -"
        fi
        echo ${PITCHER} >> ${TMPFILE}

        DAY_OF_WEEK=`expr ${DAY_OF_WEEK} + 1`
        if [ ${DAY_OF_WEEK} -gt 7 ]; then
            WEEK=`expr ${WEEK} + 1`
            DAY_OF_WEEK=1
            TMPFILE=`tmpFileName ${WEEK}`        
            cat /dev/null > ${TMPFILE}
        fi

        DATE=`date -j -v+1d -f %Y%m%d ${DATE} +%Y%m%d`
        REQ=`dateComp $DATE $TODAY`
    done
}

function outPitcherFile() {
    WEEK=1
    TMPFILE=`tmpFileName ${WEEK}`
    while [ -e ${TMPFILE} ]
    do
        echo "<PITCHERS>"
        cat ${TMPFILE}
        echo "</PITCHERS>"
        WEEK=`expr ${WEEK} + 1`
        TMPFILE=`tmpFileName ${WEEK}`
    done
}

outPictherDataFile
outPitcherFile
