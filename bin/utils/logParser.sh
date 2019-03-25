#!/bin/bash

logFileName=""
testResultLineArrayMI=""
testResultLineArrayRV=""
testResultSuccessArrayMI=""
testResultFailuresArrayMI=""
testResultTotalsArray=""
testErrorsArray=""
testCasesArray=""
successNumMI=0
successNumRV=0
totalNum=0
failureNumMI=0
failureNumRV=0
testProgramsNumberMI=0
testProgramsNumberRV=0
testCasesNumber=0
testErrorsCount=0
logFileName="$1"

sed -i "s/# //g" $logFileName

testCasesArray=`grep -oP "TESTCASE:" "$logFileName"`
for x in $testCasesArray ; do
    testCasesNumber=$(($testCasesNumber + 1))
done
if [ $testCasesNumber -eq 0 ]; then
    testCasesNumber=$(($testCasesNumber + 1))
fi

testErrorsArray=`grep -oP "_ERROR" "$logFileName"`
for x in $testErrorsArray ; do
    testErrorsCount=$(($testErrorsCount + 1))
done

testResultLineArrayMI=`grep "tests succeeded" "$logFileName"`
for x in `echo $testResultLineArrayMI | grep -oP '\/'` ; do
    testProgramsNumberMI=$(($testProgramsNumberMI + 1))
done

testResultLineArrayRV=`grep "TERMINATING WITH CODE: " "$logFileName" | sed "s/TERMINATING WITH CODE: //g"`
for x in $testResultLineArrayRV ; do
    testProgramsNumberRV=$(($testProgramsNumberRV + 1))
    if [ $x -eq 1 ]; then
        successNumRV=$(($successNumRV + 1))
    else
        failureNumRV=$(($failureNumRV + 1))
    fi
done

testResultSuccessArrayMI=`echo $testResultLineArrayMI | grep -oP '[0-9]*\/' | grep -oP '[0-9]*[^\/]'`
for x in $testResultSuccessArrayMI ; do
    successNumMI=$(($successNumMI + $x))
done

#total
#echo $testResultLineArrayMI | grep -oP '\/[0-9]+' | grep -oP '[^\/][0-9]+'
testResultTotalsArray=`echo $testResultLineArrayMI | grep -oP '\/[0-9]*' | grep -oP '[^\/][0-9]*'`
#echo $testResultTotalsArray
for x in $testResultTotalsArray ; do
    totalNum=$(($totalNum + $x))
done

#failed
#echo $testResultLineArrayMI | grep -oP '[0-9]+ tests failed' | grep -oP '[0-9]+'
testResultFailuresArrayMI=`echo $testResultLineArrayMI | grep -oP '[0-9]* tests failed' | grep -oP '[0-9]*'`
#echo $testResultFailuresArrayMI
for x in $testResultFailuresArrayMI ; do
    failureNumMI=$(($failureNumMI + $x))
done

echo "Executed testcases:   $testCasesNumber" >> $logFileName
if [ $testProgramsNumberRV -gt 0 ]; then
    echo "Test programs number: $testProgramsNumberRV" >> $logFileName
else
    echo "Test programs number: $testProgramsNumberMI" >> $logFileName
fi
echo "Tests succeeded:      $(($successNumMI+$successNumRV))" >> $logFileName
echo "Tests failed:         $(($failureNumMI+$failureNumRV))" >> $logFileName
echo "Total tests number:   $totalNum" >> $logFileName

if [ $testErrorsCount -gt 0 ]; then
    echo "" >> $logFileName
    echo Test programs failures detected: $testErrorsCount >> $logFileName
fi

echo "" >> $logFileName
if [ $(($testErrorsCount + $failureNumMI + $failureNumRV)) -gt 0 ]; then
    echo "!!!!! ERRORS DETECTED DURING SIMULATION !!!!!" >> $logFileName
else
    echo TESTS PASSED >> $logFileName
fi
echo ""
