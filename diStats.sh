#!/bin/bash

gradeFile="./grades.txt"
ectsNeeded=240

while getopts ":f:e:" opt; do
  case $opt in
    f) gradeFile="$OPTARG"
    ;;
    e) ectsNeeded="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

awk -v ECTS_NEEDED=$ectsNeeded '\
    BEGIN{
        printf "%-20s\t%-20s\t%s\n%s\n", "SubjectName", "ECTS", "Grade"\
        ,"-------------------------------------------------------\n"
        ects = 0
        weighted = 0
    }
    {\
        if(NR > 3){
            printf "%-20s\t%-20s\t%s / 10\n", $1, $2, $3
            if($3 != "-"){
                ects += $2
                weighted += $2*$3
            }
        }
    }
    END{
        printf "\n\nStatistics:\n"
        printf "-------------------------------------------------------\n"
        printf "%-15s\t%d (%d needed)\n", "ECTS:", ects, ECTS_NEEDED
        printf "%-15s\t%2.2f / 10\n", "Score:", weighted/(ects+1)
    }
' $gradeFile

