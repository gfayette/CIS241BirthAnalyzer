#George Fayette
#CIS 241 01
#birth_analyzer

BEGIN{
    FS=",";
    fileNum=0;
    firstLineRead=0;
    firstFileLineRead=0;

    monthNames[1]="January";
    monthNames[2]="February";
    monthNames[3]="March";
    monthNames[4]="April";
    monthNames[5]="May";
    monthNames[6]="June";
    monthNames[7]="July";
    monthNames[8]="August";
    monthNames[9]="September";
    monthNames[10]="October";
    monthNames[11]="November";
    monthNames[12]="December";

    dayNames[1]="Monday";
    dayNames[2]="Tuesday";
    dayNames[3]="Wednesday";
    dayNames[4]="Thursday";
    dayNames[5]="Friday";
    dayNames[6]="Saturday";
    dayNames[7]="Sunday";
}

#Skip lines that contain characters other than digits and commas
/[^[:digit:]\,]/{ next }

{
    #Skip lines that don't contain five fields
    if(NF != 5){
        print "Error on line "FNR" in file: "FILENAME". Number of fields is not 5.";
        next;
    }

    #Skip lines with invalid month numbers
    if($2 > 12 || $2 < 1){
        print"Error on line "FNR" in file: "FILENAME". Invalid month.";
        next;
    }

    #Skip lines with invalid day numbers
    if($4 > 7 || $4 < 1){
         print"Error on line "FNR" in file: "FILENAME". Invalid weekday.";
         next;
    }

    if(firstLineRead==0){
        firstLineRead=1;
        minBirths=$5;
        maxBirths=$5;
        minBirthDate=monthNmaes[$2]" "$3", "$1;
        maxBirthDate=monthNames[$2]" "$3", "$1;
    }

    if(firstFileLineRead==0){
        firstFileLineRead=1;
        fileNum++;
        fileNames[fileNum]=FILENAME;
        firstYearInFile[fileNum]=$1;
    }

    birthsByMonth[fileNum][$1][$2]+=$5;
    birthsByDay[fileNum][$1][$4]+=$5;
    totalBirths[fileNum][$1]+=$5;
    numDays[fileNum][$1]+=1;
    lastYearInFile[fileNum]=$1;

    if($5 < minBirths){
        minBirths=$5; 
        minBirthDate=monthNames[$2]" "$3", "$1;
    }

    if($5 > maxBirths){
        maxBirths=$5; 
        maxBirthDate=monthNames[$2]" "$3", "$1;
    }    
}

ENDFILE{
    firstFileLineRead=0;
}

END{
    for(i=1;i<=fileNum;i++){

        print"########################################################################";
        print "File: "fileNames[i];
        print"########################################################################\n";

        for(j=firstYearInFile[i];j<=lastYearInFile[i];j++){

            #Print warning if the number of days in a year is less than or greater than expected
            if(numDays[i][j]<365||numDays[i][j]>366){
                print "Warning! Year "j" has data for "numDays[i][j]" days."
            }

            print "Year: "j;
            print"\nBirths by month:\n";        
            totalPercentage=0;

            for(k=1;k<=12;k++){

                if(totalBirths[i][j]!=0){  
                    percentOfTotal=100*birthsByMonth[i][j][k]/totalBirths[i][j];
                    totalPercentage+=percentOfTotal;
                }else{
                    percentOfTotal="NA";
                    totalPercentage="NA";
                }

                col1=monthNames[k]" births: ";
                printf("%-20s %20d %18.2f %1s\n", col1, birthsByMonth[i][j][k], percentOfTotal, "%");

            }
                     
            print"\n===============================================================\n";
            printf("%-20s %20d %18.2f %1s\n","Total:", totalBirths[i][j], totalPercentage, "%");

            print"\nBirths by day of week:\n";
            totalPercentage=0;

            for(k=1;k<=7;k++){

                if(totalBirths[i][j]!=0){
                    percentOfTotal=100*birthsByDay[i][j][k]/totalBirths[i][j];
                    totalPercentage+=percentOfTotal;
                }else{
                    percentOfTotal="NA";
                    totalPercentage="NA";
                }

                col1=dayNames[k]" births: ";
                printf("%-20s %20d %18.2f %1s\n", col1 , birthsByDay[i][j][k], percentOfTotal, "%");
            }

            print"\n==============================================================\n";
            printf("%-20s %20d %18.2f %1s\n","Total:", totalBirths[i][j], totalPercentage, "%");

            dailyAverage=totalBirths[i][j]/numDays[i][j];
            monthlyAverage=totalBirths[i][j]/12;
            printf("\n%-21s %19d\n", "Days in year: ", numDays[i][j])
            printf("%-20s %23.2f\n", "Daily average: ", dailyAverage);
            printf("%-20s %23.2f\n", "Monthly average: ", monthlyAverage);

            print"\n**************************************************************\n";
        }
    }

    printf("\n%-30s %30s\n", "Date with least births: ", minBirthDate);
    printf("%-30s %30d\n", "Number of births: ", minBirths);

    printf("\n%-30s %30s\n", "Date with most births: ", maxBirthDate);
    printf("%-30s %30d\n", "Number of births: ", maxBirths);
}
