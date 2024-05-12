#!/bin/bash

NUKE="Nuke13.2"
LOGS="../logs"
NUKESCRIPTS="../nukescripts"
CACHE="/var/tmp/nuke-u1000"
CYCLES=5
VARIANTS=("Dots" "NoOps" "Stamps")


## Profile the Profiler, 1000 frames
PROFILERS=("SpiralProfiler")
RANGE="0-999"

for c in $(seq 1 $CYCLES)
do
	for p in ${!PROFILERS[@]}
	do
		for v in ${!VARIANTS[@]}
		do
			NOW=`date '+%F_%H-%M-%S'`
			PROFILER="${PROFILERS[$p]}_${VARIANTS[$v]}"
			NUKESCRIPT="${PROFILER}.nk"
			LOG="${PROFILER}_${NUKE}_Cycle${c}_Frames${RANGE}"
			echo $NOW "Profiling ${PROFILER} - Cycle ${c}"
			
			killall $NUKE 
			rm -R $CACHE

			$NUKE -c 4G -F $RANGE -m 4 -V -x "${NUKESCRIPTS}/${NUKESCRIPT}" > "${LOGS}/${LOG}_stdout.txt" 2>&1 &
			sleep 1
			./LogCpuMem.sh `pidof $NUKE` | tee "${LOGS}/${LOG}_cpumem.txt"
		done
	done
done