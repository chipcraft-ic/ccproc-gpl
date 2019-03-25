#!/bin/bash

echo STARTTED
while [ ! 0 -lt $(ls ../.testcase_job_*.lock 2>/dev/null | wc -w) ]
do
    sleep 1
done
echo WAITING
while [ 0 -lt $(ls ../.testcase_job_*.lock 2>/dev/null | wc -w) ]
do
    sleep 2
done
echo ENDED
make testcases-merge
