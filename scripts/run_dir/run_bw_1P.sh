#!/bin/bash
echo '*********************************'
echo '      lmbench bw_mem     32M       '
echo '*********************************'
export LMBENCH_SCHED="DEFAULT"

echo '**********core0*************'
for THREAD_NUM in 1
do
	for size in  32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			taskset -c 0 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


echo '***********clu0**************'
for THREAD_NUM in 4
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			taskset -c 0-3 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**************die0**************'
for THREAD_NUM in 16
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			taskset -c 0-15 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**********CPU0*************'
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

echo '**********core0 Ta->Tb*************'
for THREAD_NUM in 1
do
	for size in  32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl -C 0 -m 1 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


echo '***********clu0 Ta->Tb**************'
for THREAD_NUM in 4
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl -C 0-3 -m 1 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**************die0 Ta->Tb**************'
for THREAD_NUM in 16
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl -C 0-15 -m 1 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


