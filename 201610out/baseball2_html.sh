#!/usr/local/bin/bash

function convertToHtml() {
cat $1 |\
sed -e "s|FileName:\(.*\)|<tr><td><a href=\"${URL_BASE}/\1/\">\1</a></td>|g" |\
sed -e 's|<OUTS>|<td><table>|g' |\
sed -e 's/<OUT>\(.*\)\,\(.*\)\,\(.*\),\(.*\),\(.*\),\(.*\)<\/OUT>/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><td>\4<\/td><td>\5<\/td><td>\6<\/td><\/tr>/g' |\
sed -e 's/<\/OUTS>/<\/table><\/td>/g' |\
sed -e 's/<INS>/<td><table>/g' |\
sed -e 's/<IN>\(.*\)\,\(.*\)\,\(.*\),\(.*\),\(.*\)<\/IN>/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><td>\4<\/td><td>\5<\/td><\/tr>/g' |\
sed -e 's/<\/INS>/<\/table><\/td>/g' |\
sed -e 's/\[STARTING PITCHER\]/<td>/g' |\
sed -e 's/\[OPPONET PITCHER\]/<td>/g' |\
sed -e 's/.*,投,\(.*\),\(.*\),---/<table><tr><td>\1<\/td><td>\2<\/td><\/tr><\/table>/g'
}

function convertSUMToHtml() {
cat $1 |\
sed -e 's|<OUT_LIST>|<h3>今季スタメン落ち一覧</h3><ul>|g' |\
sed -e 's|</OUT_LIST>|</ul>|g' |\
sed -e 's|<OUT_LIST_AVE>|<h3>成績が理由でスタメン落ち？</h3><ul>|g' |\
sed -e 's|</OUT_LIST_AVE>|</ul>|g' |\
sed -e 's|<OUT_LIST_NONAVE>|<h3>成績が理由でスタメン落ちではなさそう</h3><ul>|g' |\
sed -e 's|</OUT_LIST_NONAVE>|</ul>|g' |\
sed -e 's|<OUT>\(.*\)<\/OUT>|<li>\1</li>|g' 
}

TEAM=$1
URL_BASE=$2

WORKDIR="/home/taichiwbb/www"
DATAFILE="${WORKDIR}/${TEAM}.txt"
SUM_DATAFILE="${WORKDIR}/${TEAM}_SUM.txt"
OUTFILE="${WORKDIR}/${TEAM}.html"

cat << EOS > ${OUTFILE}
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${TEAM} - スタメン好き</title>
</head>
<body>
<a href="/">スタメン好き</a>
<h1>${TEAM}</h1>
<h2>なんでスタメン落ちした？</h2>
<table border="1">
<tr><th>Date</th><th>OUT</th><th>IN</th><th>先発投手</th><th>相手投手</th></tr>
`convertToHtml ${DATAFILE}`
</table>
`convertSUMToHtml ${SUM_DATAFILE}`
<a href="./Fighters.html">Fighters</a>
<a href="./Eagles.html">Eagles</a>
<a href="./Lions.html">Lions</a>
<a href="./Marines.html">Marines</a>
<a href="./Buffaloes.html">Buffaloes</a>
<a href="./Hawks.html">Hawks</a>
</body>
</html>
EOS
 
