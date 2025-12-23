#!/bin/bash
#Title: Skill vs tick graphing program
#Description: Graphs the progression of skill as it regards to skill ticks
#Note: Skill is based on time not tick rate, so this is for educational and personal usage only
#Author: Polarbear
#Last Update: 02/08/2023



#read in skills list for each graph:
mkdir -pv output
input='SkillList.text'
IFS=$'\n'
C=0
while read skill; do
	numwords=$(wc -w <<< "$skill")
	## Create Graphs:
	increases="${skill} increased by"
	columnNum=$(expr 7 + ${numwords} - 1 )
	outfile="output/${skill}.png"
	echo "Now outputing file ${outfile}"
	echo "Column num: ${columnNum}"
	rg "$increases"  _Skills.20* | awk -v cc=$columnNum '{print $cc}' | sort -nk1 | gnuplot -p -e 'set xlabel "Number of Ticks";set ylabel "'${skill}' skill";set term png;set output "'"${outfile}"'"; plot "-" u 1 w l;set term x11'


done < "$input"
