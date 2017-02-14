#!/bin/bash
echo '*********************************'
echo '      lmbench bw_mem     32M       '
echo '*********************************'
export LMBENCH_SCHED="DEFAULT"

echo '**********core0*************'
for THREAD_NUM in 2
do
	for size in  32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			taskset -c 0,16 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


echo '***********clu0**************'
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

echo '**************die0**************'
for THREAD_NUM in 32
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			taskset -c 0-31 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


