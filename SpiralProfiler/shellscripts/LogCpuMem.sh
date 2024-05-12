#!/bin/bash
pid=$1
echo 'CPU MEM'
while ps -p $pid &> /dev/null; do
    top -b -n 2 -d 0.5 -p $pid | tail -1 | awk '{print $9","$10}'
done
