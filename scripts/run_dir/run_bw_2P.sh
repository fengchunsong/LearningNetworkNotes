#!/bin/bash
echo '*********************************'
echo '      lmbench bw_mem     32M       '
echo '*********************************'
export LMBENCH_SCHED="DEFAULT"

echo '**********2P core0*************'
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


echo '***********2P clu0**************'
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

echo '**************2P die0**************'
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

echo '**********2P CPU0*************'
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

echo '**********2P CPU12*************'
for THREAD_NUM in 64
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl -C 0-63 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**********2P TA->TC core0*************'
for THREAD_NUM in 1
do
	for size in  32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
		   numactl --membind=1 --physcpubind=0  ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done


echo '***********2P TA->TC clu0**************'
for THREAD_NUM in 4
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl --membind=1 --physcpubind=0-3 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done

echo '**************2P PTA->TC die0**************'
for THREAD_NUM in 16
do
	for size in 32M
	do
		for bm in rd frd wr fwr bzero rdwr cp fcp bcopy 
		do		
			numactl --membind=1 --physcpubind=0-15 ./bw_mem -P $THREAD_NUM -N 5 $size $bm
		done
	done
done



