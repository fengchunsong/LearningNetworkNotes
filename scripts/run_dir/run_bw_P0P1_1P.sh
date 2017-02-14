#!/bin/bash
echo '*********************************'
echo '      lmbench bw_mem     32M       '
echo '*********************************'
export LMBENCH_SCHED="DEFAULT"


echo '**********P0<->P1 core0*************'
for THREAD_NUM in 2
do
	for size in  32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
		    numactl -C 0,32  ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


echo '***********P0<->P1 clu0**************'
for THREAD_NUM in 8
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			 taskset -c 0-3,16-19 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**************P0<->P1 die0**************'
for THREAD_NUM in 32
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			taskset -c 0-15,16-31  ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done



