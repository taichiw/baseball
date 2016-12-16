#!/usr/local/bin/bash

cd /home/taichiwbb/bin/out

function makefile() {
    TEAM=$1
    URL_BASE=$2

#echo $TEAM

    ./baseball2.sh ${TEAM} ${URL_BASE}
    ./baseball2_ana.sh ${TEAM}
    ./baseball2_html.sh ${TEAM} ${URL_BASE}
}

TEAM="Eagles"
URL_BASE="http://www.rakuteneagles.jp/gamelive/result"
makefile ${TEAM} ${URL_BASE} 

TEAM="Fighters"
URL_BASE="http://www.fighters.co.jp/gamelive/result"
makefile ${TEAM} ${URL_BASE} 

TEAM="Hawks"
URL_BASE="http://www.softbankhawks.co.jp/gamelive/result"
makefile ${TEAM} ${URL_BASE} 

TEAM="Lions"
URL_BASE="http://www.seibulions.jp/gamelive/result"
makefile ${TEAM} ${URL_BASE} 

TEAM="Marines"
URL_BASE="http://www.marines.co.jp/gamelive/result"
makefile ${TEAM} ${URL_BASE} 

TEAM="Buffaloes"
URL_BASE="http://www.buffaloes.co.jp/gamelive/result"
makefile ${TEAM} ${URL_BASE} 
