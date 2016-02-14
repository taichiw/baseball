//Usage: go run readline.go < c_pitcher.txt

package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"os"
)

type Pitcher struct {
	date  string
	pitcher string
	winpitcher string
}

type Ace struct {
	pitcher string
	winnum	int
}

func main() {
	var pList = readData()
	//fmt.Println(pList)
	
	//Start game's pitcher is first ace
	var ace = Ace{pList[0].pitcher, 0}

	var pMap map[string]int = map[string]int{}
	for _, p := range pList {
		fmt.Printf("%s\t%s\t%d\t%s\n", p.date, ace.pitcher, ace.winnum, p.pitcher)

		//fmt.Println(i)
		//fmt.Println(p.pitcher)
		if p.pitcher == p.winpitcher {
			winnum := pMap[p.pitcher]
			winnum += 1
			pMap[p.pitcher] = winnum
			//fmt.Printf("%s:%d\n", p.pitcher, pMap[p.pitcher])
			
			if winnum > ace.winnum {
				ace.pitcher = p.pitcher
				ace.winnum = winnum
			}
		}
	}

}

func readData() ([]Pitcher) {
	var fp *os.File
	var err error

	if len(os.Args) < 2 {
		fp = os.Stdin
	} else {
		fmt.Printf(">> read file: %s\n", os.Args[1])
		fp, err = os.Open(os.Args[1])
		if err != nil {
			panic(err)
		}
		defer fp.Close()
	}

	reader := csv.NewReader(fp)
	reader.Comma = '\t'
	reader.LazyQuotes = true

	pList := make([]Pitcher, 0)
	//fmt.Println(pList)

	for {
		record, err := reader.Read()
		if err == io.EOF {
			break
		} else if err != nil {
			panic(err)
		}
		var p = Pitcher{record[0], record[1], record[2]}
		//fmt.Println(p)
		
		pList = append(pList, p)
	}
	return pList
}
