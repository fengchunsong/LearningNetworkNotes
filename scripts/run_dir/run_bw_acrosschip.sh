#!/bin/bash
echo '*********************************'
echo '      lmbench bw_mem     32M       '
echo '*********************************'
export LMBENCH_SCHED="DEFAULT"

echo '**********core0 P0TA->P1TA*************'
for THREAD_NUM in 1
do
	for size in  32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
		    numactl -C 0 -m 2 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


echo '***********clu0  P0TA->P1TA* *************'
for THREAD_NUM in 4
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			 numactl -C 0-3 -m 2 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**************die0   P0TA->P1TA**************'
for THREAD_NUM in 16
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl -C 0-15 -m 2 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '*********************************'
echo '      lmbench bw_mem     32M       '
echo '*********************************'
export LMBENCH_SCHED="DEFAULT"

echo '**********core0 P0TB->P1TB*************'
for THREAD_NUM in 1
do
	for size in  32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
		    numactl -C 16 -m 3 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


echo '***********clu0 P0TB->P1TB**************'
for THREAD_NUM in 4
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			 numactl -C 16-19 -m 3 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**************die0 P0TB->P1TB**************'
for THREAD_NUM in 16
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl -C 16-31 -m 3 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


