import java.nio.file.*
import java.util.stream.Stream

//jshell note
//setstartに一回適当な処理を入れたら再起動しても消えなくなった。戻し方わからず、からファイルを作ってsetstart dummy. そのあとからファイルを消しても問題なく動いてた。
//import周りがもう少しやりやすいといいなぁ
//jshell関係ないけど　メソッドチェーンのインデントってみんなどう書いてるの？
//openコマンド便利...　と思ってたけど、クラス定義しようとしたらだんだんめんどくなってきた。シンタックスエラーがどこで起こってるのかわかりにくい。もはやコンパイルしてるのと変わらない
//メソッドチェーンのドットを頭にかけない（irbなども同じっぽいが）

Files.lines(
	Paths.get("c_pitcher.txt")).
		forEach(
			str -> Arrays.stream(str.split("\t")).
			forEach(System.out::println)).
			collec
