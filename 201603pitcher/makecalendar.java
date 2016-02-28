/*
 * This program is just for jshell.
 */


import java.nio.file.*;
import java.nio.charset.*;
import java.io.*;
import java.util.Arrays;
import java.util.stream.*;
import java.time.*;
import java.time.format.*;
import java.time.temporal.*;
import java.util.*;

//change this variable
String team = "bs";

class Pitch {
    
    public LocalDate date;
    public String name;
    
    public static Pitch factory (String[] arr) {
        Pitch p = new Pitch();
        p.date = LocalDate.parse(arr[0], DateTimeFormatter.ofPattern("yyyy-M-d"));
        p.name = arr[1];
        //System.out.println(p.name);
        return p;
    }
}

//class MakeCalendar {
//public static void main(String args[]) throws Exception {
    List<Pitch> pitches = Files.lines(Paths.get(team + "_pitcher.txt")).
        map(str -> Pitch.factory(str.split("\t"))).
        collect(Collectors.toList());
//    forEach(p -> System.out.println(p.date.get(ChronoField.ALIGNED_WEEK_OF_YEAR)))
//    forEach(p -> System.out.println(p.date.getDayOfWeek().getValue()))
    
    //開幕ローテーション
    List<String> openingRotation = new ArrayList<>();
    String opneningPitcher = pitches.get(0).name;
    openingRotation.add(opneningPitcher);
    for (int i=1;;i++) {
        Pitch p = pitches.get(i);
        if(p.name.equals(opneningPitcher)) {
            break;
        } else {
            openingRotation.add(p.name);
        }
    }
    
    //Not 開幕ローテーション
    List<String> nonOpRotation = new ArrayList<>();
    
    LocalDate openingGameDate = pitches.get(0).date;
    LocalDate lastGameDate    = pitches.get(pitches.size() - 1).date;
    
    //Calendar
    List<LocalDate> seasonDates = new ArrayList<>();
    for (LocalDate date = openingGameDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY)); date.compareTo(lastGameDate) < 1; date = date.plusDays(1)) {
        seasonDates.add(date);
    }
    
    List<List<String>> pitchCalendar = new ArrayList<>();
    List<String> weeklyPicthCalendar = null;
    for(LocalDate date : seasonDates) {
        //System.out.println(date.getDayOfWeek());
        if (date.getDayOfWeek().equals(DayOfWeek.SUNDAY)) {
            if (weeklyPicthCalendar != null) {
                pitchCalendar.add(weeklyPicthCalendar);
            }
            weeklyPicthCalendar = new ArrayList<>();
            weeklyPicthCalendar.add(date.toString());
        }
        List<Pitch> pl = pitches.stream().filter(p -> p.date.equals(date)).collect(Collectors.toList());
        if (pl.size() == 0) {
            weeklyPicthCalendar.add("-");
        } else {
            String name = pl.get(0).name;
            int opRotationIdx = openingRotation.indexOf(name);
            int nonOpRotationIdx = nonOpRotation.indexOf(name);
            if (opRotationIdx < 0 && nonOpRotationIdx < 0) {
                nonOpRotation.add(name);
                nonOpRotationIdx = nonOpRotation.indexOf(name);
            }
            
            weeklyPicthCalendar.add((opRotationIdx >= 0 ? "O" + (opRotationIdx + 1) : "M" + (nonOpRotationIdx + 1)));
        }
    }
    pitchCalendar.add(weeklyPicthCalendar);
    
    StringBuilder sb = new StringBuilder();
    sb.append(" \t日\t月\t火\t水\t木\t金\t土\r\n");
    pitchCalendar.stream().
        map(c -> String.join("\t", c)).
        //forEach(System.out::println);
        forEach(s -> sb.append(s + "\r\n"));
    sb.append("\r\n");
    IntStream.range(0, openingRotation.size()).
        boxed().
        map(idx -> "O" + (idx+1) + openingRotation.get(idx)).
        //forEach(System.out::println);
        forEach(s -> sb.append(s + "\r\n"));
    sb.append("\r\n");
    IntStream.range(0, nonOpRotation.size()).
        boxed().
        map(idx -> "M" + (idx+1) + nonOpRotation.get(idx)).
        //forEach(System.out::println);
        forEach(s -> sb.append(s + "\r\n"));
    
    System.out.print(sb.toString());
    
    Files.write(Paths.get(team + "_pitcher_calendar.tsv"), Arrays.asList(sb.toString()), Charset.forName("UTF-8"));

//}
//}