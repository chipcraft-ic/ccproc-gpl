#!/bin/bash

echo STARTTED
while [ ! 0 -lt $(ls ../.torture_job_*.lock 2>/dev/null | wc -w) ]
do
    sleep 1
done
echo WAITING
while [ 0 -lt $(ls ../.torture_job_*.lock 2>/dev/null | wc -w) ]
do
    sleep 2
done
echo ENDED
make torture-merge
