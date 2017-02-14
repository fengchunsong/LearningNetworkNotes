#!/bin/bash
echo '*********************************'
echo '     benchmark_test     '
echo '*********************************'
export LMBENCH_SCHED="DEFAULT"

#cp run_coremark.sh ../coremark_v1.0/coremark_v1.0/
#cd ../coremark_v1.0/coremark_v1.0/
#chmod +x run_coremark.sh
#./run_coremark.sh
#cd ../../run_dir

cp run_bw_1P.sh  ../9_lmbench_a9/bin/
cp run_bw_acrossdie.sh  ../9_lmbench_a9/bin/
cp run_lat1P.sh  ../9_lmbench_a9/bin/
cp run_stream1P.sh ../9_lmbench_a9/bin/
chmod +x *.sh
cd  ../9_lmbench_a9/bin/
./run_bw_1P.sh
./run_bw_acrossdie.sh
./run_lat1P.sh
./run_stream1P.sh
cd ../../run_dir


