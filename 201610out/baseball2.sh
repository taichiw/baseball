#!/usr/local/bin/bash

function dateComp()
{
    ARG1_SECOND=$1
    ARG2_SECOND=$2

    expr $ARG1_SECOND - $ARG2_SECOND
}

TEAM=$1
URL_BASE=$2

CURL="/usr/local/bin/curl"
NKF="/usr/local/bin/nkf"

OUTDIR="/home/taichiwbb/tmp/${TEAM}"
rm -r ${OUTDIR}
if [ ! -e ${OUTDIR} ]; then
    mkdir ${OUTDIR}
fi

OPENING_DAY=20160325
TODAY=`date +%Y%m%d`

DATE=${OPENING_DAY}
GAME_NO=1

REQ=`dateComp $DATE $TODAY`
while [ ${REQ} -lt 0 ]
do

    FILENAME="${DATE}01"
    HTML_FILENAME="${OUTDIR}/${FILENAME}"
    TEMP_FILENAME="${OUTDIR}/tmp${FILENAME}"
    TEMP_FILENAME2="${OUTDIR}/tmp${FILENAME}2"
    TEMP_FILENAME3="${OUTDIR}/tmp${FILENAME}3"
    
    
    OUTFILE=${OUTDIR}/`printf "%.3d" ${GAME_NO}`_${FILENAME}_${TEAM}.dat
    
    URL="${URL_BASE}/${FILENAME}/"
    
    HTTP_STATUS=`${CURL} -I ${URL} -o /dev/null -w '%{http_code}\n' -s`
    if [ ${HTTP_STATUS} = '200' ]; then
        ${CURL} -s "${URL}" -o ${HTML_FILENAME}
        ${NKF} -w --overwrite ${HTML_FILENAME}
        sed -n -e '/<table class="tableMembers01">/,/<\/table>/p' ${HTML_FILENAME} > ${TEMP_FILENAME}
        
        cat /dev/null > ${TEMP_FILENAME3}
        for i in `seq 1 9` -
        do
        	sed -n -e "/<td class=\"commonNum01 p${TEAM}01\">${i}/,/<\/tr>/p" ${TEMP_FILENAME} > ${TEMP_FILENAME2}
        	cat ${TEMP_FILENAME2} | awk 'NR==1' | awk -F '</td>' '{print $1}' | awk -F '>' '{print $NF}' >> ${TEMP_FILENAME3}
        	cat ${TEMP_FILENAME2} | awk 'NR==2' | awk -F '</p>' '{print $1}' | awk -F '>' '{print $NF}' >> ${TEMP_FILENAME3}
        	cat ${TEMP_FILENAME2} | awk 'NR==3' | awk -F '</p>' '{print $1}' | sed -e 's/<\/a>//' | awk -F '>' '{print $NF}' >> ${TEMP_FILENAME3}
        	cat ${TEMP_FILENAME2} | awk 'NR==4' | awk -F '</p>' '{print $1}' | awk -F '>' '{print $NF}' >> ${TEMP_FILENAME3}
        	cat ${TEMP_FILENAME2} | awk 'NR==6' | awk -F '</p>' '{print $1}' | awk -F '>' '{print $NF}' >> ${TEMP_FILENAME3}
        done
        
        #Opponet Pitcher
        grep '<td><p>投</p></td>' ${HTML_FILENAME} -n > ${TEMP_FILENAME}
		while read line; do
			LINE_NO=`echo ${line} | awk -F ':' '{print $1}'`
			B_LINE_NO=`expr ${LINE_NO} - 1`
			A_LINE_NO=`expr ${LINE_NO} + 1`
			A2_LINE_NO=`expr ${LINE_NO} + 2`

			IS_EAGLE=`awk "NR==${B_LINE_NO}" ${HTML_FILENAME}| grep p"${TEAM}"01 | wc -l`
			if [ ${IS_EAGLE} -eq 0 ]; then
				echo "相手" >> ${TEMP_FILENAME3}
				echo "投" >> ${TEMP_FILENAME3}
				awk "NR==${A_LINE_NO}" ${HTML_FILENAME} | awk -F '</p>' '{print $1}' | sed -e 's/<\/a>//' | awk -F '>' '{print $NF}' >> ${TEMP_FILENAME3}
				awk "NR==${A2_LINE_NO}" ${HTML_FILENAME} | awk -F '</p>' '{print $1}' | awk -F '>' '{print $NF}' >> ${TEMP_FILENAME3}
				echo "---" >> ${TEMP_FILENAME3}
			fi
		done < ${TEMP_FILENAME}
        
        
        cat ${TEMP_FILENAME3} | paste -d , - - - - - > ${OUTFILE}
        
        rm ${HTML_FILENAME}
        rm ${TEMP_FILENAME}
        rm ${TEMP_FILENAME2}
        rm ${TEMP_FILENAME3}
        
        if [ -s ${OUTFILE} ]; then
	        GAME_NO=`expr $GAME_NO + 1`
	    else
	    	rm ${OUTFILE}
	    fi
    fi
    
    DATE=`date -j -v+1d -f %Y%m%d ${DATE} +%Y%m%d`
    
    REQ=`dateComp $DATE $TODAY`
done

