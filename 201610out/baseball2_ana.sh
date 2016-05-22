#!/usr/local/bin/bash

function fileName()
{
    GAME_NO=$1
    FILE_NAME="${WORKDIR}/`printf "%.3d" ${GAME_NO}`_*_${TEAM}.dat"
    ls ${FILE_NAME} 2> /dev/null
}

TEAM=$1

WORKDIR="/home/taichiwbb/tmp/${TEAM}"

GAME_NO_1=1
GAME_NO_2=2

OPENFILE=`fileName $GAME_NO_1`
COMPFILE=`fileName $GAME_NO_2`

OUTFILE="/home/taichiwbb/www/${TEAM}.txt"
OUTFILE_SUM="/home/taichiwbb/www/${TEAM}_SUM.txt"

function opponentPicther() {
    grep '相手,投,' ${COMPFILE}
}

function outData() {
while [ $? -eq 0 ]
do
    #echo ${OPENFILE}
    echo "FileName:`echo ${COMPFILE} | awk -F '_' {'print $2'}`" 
    
    OUTTMP="${WORKDIR}/out.tmp"
    cat /dev/null > ${OUTTMP}
    
    while read line ; do
        if [ `echo ${line} | grep ',投,' | wc -l` -gt 0 ]; then
            continue
        fi
        PERSON=`echo ${line} | awk -F ',' '{print $3}'`
        PLAY=`grep ${PERSON} ${COMPFILE} | grep -v ',投,' | wc -l`
        if [ ${PLAY} -eq 0 ]; then
            OUTED=`grep ${PERSON} ${OPENFILE}`

            REASON=""

            #AVE
            AVE=`echo ${OUTED} | awk -F ',' '{print $5}' | sed -e 's/\.//'`	
	    if [ ${AVE} -lt 250 ]; then
                REASON="AVE|"
            fi
            
            #SAYU-BYOU
            OPP_P=`opponentPicther`
            OPP_P_LR=`echo ${OPP_P} | awk -F ',' '{print $4}'`
            B_LR=`echo ${OUTED} | awk -F ',' '{print $4}'`
            if [ ${OPP_P_LR} = '左' -a ${B_LR} = '左' ]; then
                REASON="${REASON}LvsL|"
            fi

            echo "${OUTED},${REASON}" >> ${OUTTMP}
        fi
    done < ${OPENFILE}
    echo "<OUTS>" 
    if [ -s ${OUTTMP} ]; then
        cat ${OUTTMP} | sed 's/\(.*\)/<OUT>\1<\/OUT>/g'
    fi
    echo "</OUTS>"

    cat /dev/null > ${OUTTMP}
    while read line ; do
        if [ `echo ${line} | grep ',投,' | wc -l` -gt 0 ]; then
            continue
        fi
        PERSON=`echo ${line} | awk -F ',' '{print $3}'`
        PLAY=`grep ${PERSON} ${OPENFILE} | grep -v ',投,' | wc -l`
        if [ ${PLAY} -eq 0 ]; then
            grep ${PERSON} ${COMPFILE} >> ${OUTTMP}
        fi
    done < ${COMPFILE}
    echo "<INS>"
    if [ -s ${OUTTMP} ]; then
        cat ${OUTTMP} | sed 's/\(.*\)/<IN>\1<\/IN>/g'
    fi
    echo "</INS>"
    
    #Catcher Change -> Pitcher
    echo "[STARTING PITCHER]"
    grep -v '相手,投,' ${COMPFILE} | grep ',投,'
    
    #Opponet Pitcher
    echo "[OPPONET PITCHER]"
    echo `opponentPicther`

    
    GAME_NO_1=`expr ${GAME_NO_1} + 1`
    GAME_NO_2=`expr ${GAME_NO_2} + 1`
    
    OPENFILE=`fileName $GAME_NO_1`
    COMPFILE=`fileName $GAME_NO_2`
done
}

outData > ${OUTFILE}


function outList(){
echo '<OUT_LIST>'
LIST=`grep '<OUT>' ${OUTFILE} | awk -F ',' '{print $3}' | sort | uniq -c | sort -r`
while read line
do
    echo "<OUT>${line}</OUT>"
done << END
${LIST}
END
echo '</OUT_LIST>'
}

function outList_Ave(){
echo '<OUT_LIST_AVE>'
LIST=`grep '<OUT>' ${OUTFILE} | grep 'AVE' | awk -F ',' '{print $3}' | sort | uniq -c | sort -r`
while read line
do
    echo "<OUT>${line}</OUT>"
done << END
${LIST}
END
echo '</OUT_LIST_AVE>'
}

function outList_NonAve(){
echo '<OUT_LIST_NONAVE>'
LIST=`grep '<OUT>' ${OUTFILE} | grep -v 'AVE' | awk -F ',' '{print $3}' | sort | uniq -c | sort -r`
while read line
do
    NAME=`echo ${line} | awk '{print $2}'`
    NUM_LvsL=`grep '<OUT>' ${OUTFILE} | grep ${NAME} | grep 'LvsL' | wc -l`
    echo "<OUT>${line} （左対左 ${NUM_LvsL}回）</OUT>"
done << END
${LIST}
END
echo '</OUT_LIST_NONAVE>'
}

cat /dev/null > ${OUTFILE_SUM}

outList        >> ${OUTFILE_SUM}
outList_Ave    >> ${OUTFILE_SUM}
outList_NonAve >> ${OUTFILE_SUM}

