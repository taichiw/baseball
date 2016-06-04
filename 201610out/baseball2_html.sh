#!/usr/local/bin/bash

function convertToHtml() {
cat $1 |\
sed -e "s|FileName:\(.*\)|<tr><td><a href=\"${URL_BASE}/\1/\">\1</a></td>|g" |\
sed -e 's|<OUTS>|<td class="out"><table>|g' |\
sed -e 's/<OUT>\(.*\)\,\(.*\)\,\(.*\),\(.*\),\(.*\),\(.*\)<\/OUT>/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><td>\4<\/td><td>\5<\/td><td>\6<\/td><\/tr>/g' |\
sed -e 's/<\/OUTS>/<\/table><\/td>/g' |\
sed -e 's/<INS>/<td class="in"><table>/g' |\
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
sed -e 's|<OUT>\(.*\) \(.*\)<OUT_DETAIL>\(.*\)</OUT_DETAIL></OUT>|<li>\1 <a href="?player=\2">\2</a> \3</li>|g' 
}

TEAM=$1
URL_BASE=$2

WORKDIR="/home/taichiwbb/www"
DATAFILE="${WORKDIR}/${TEAM}.txt"
SUM_DATAFILE="${WORKDIR}/${TEAM}_SUM.txt"
OUTFILE="${WORKDIR}/${TEAM}/index.html"

cat << EOS > ${OUTFILE}
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!--<meta name="viewport" content="width=device-width">-->
<title>${TEAM} - スタメン好き</title>
<script type="text/javascript" src="http://ajax.microsoft.com/ajax/jquery/jquery-1.4.2.min.js"></script> 
<script type="text/javascript" src="/focusToThePlayer.js"></script> 
<link rel="stylesheet" type="text/css" href="/css.css">
</head>
<body>
<nav class="breadcrumbs">
<ol>
<li itemtype="http://data-vocabulary.org/Breadcrumb">
<a itemprop="url" href="/"><span itemprop="title">スタメン好き</span></a> ＞
</li>
<li itemtype="http://data-vocabulary.org/Breadcrumb">
<a itemprop="url" href="/${TEAM}"><span itemprop="title">${TEAM}</span></a>
</li>
</ol>
</nav>
<h1>${TEAM}</h1>
<h2>なんでスタメン落ちした？</h2>
<table border="1" id="iotable">
<thead>
<tr><th>Date</th><th>OUT</th><th>IN</th><th>先発投手</th><th>相手投手</th></tr>
</thead>
<tbody>
`convertToHtml ${DATAFILE}`
</tbody>
</table>
`convertSUMToHtml ${SUM_DATAFILE}`
<nav id='teamNavi'>
<ul>
<li><a href="/Fighters/">Fighters</a></li>
<li><a href="/Eagles/">Eagles</a></li>
<li><a href="/Lions/">Lions</a></li>
<li><a href="/Marines/">Marines</a></li>
<li><a href="/Buffaloes/">Buffaloes</a></li>
<li><a href="/Hawks/">Hawks</a></li>
</ul>
</nav>
</body>
</html>
EOS
 
