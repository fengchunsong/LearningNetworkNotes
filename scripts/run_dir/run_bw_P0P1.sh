#!/bin/bash
echo '*********************************'
echo '      lmbench bw_mem     32M       '
echo '*********************************'
export LMBENCH_SCHED="DEFAULT"

echo '**********P0->P1 core0*************'
for THREAD_NUM in 1
do
	for size in  32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
		    numactl -C 0  ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


echo '***********P0->P1 clu0**************'
for THREAD_NUM in 4
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			 numactl -C 0-3 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**************P0->P1 die0**************'
for THREAD_NUM in 16
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl -C 0-15  ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**********P0->P1 CPU0*************'
for THREAD_NUM in 32
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl -C 0-31 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

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
			 numactl -C 0-3,32-35 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
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
			numactl -C 0-15,32-47  ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**********P0<->P1 CPU0*************'
for THREAD_NUM in 64
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl -C 0-31,32-63 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


