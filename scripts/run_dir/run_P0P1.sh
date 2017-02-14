#!/bin/bash
echo '*********************************'
echo '     benchmark_testP0->P1     '
echo '*********************************'
export LMBENCH_SCHED="DEFAULT"

#cp run_coremark.sh ../cd coremark_v1.0/coremark_v1.0/
#cd ../coremark_v1.0/coremark_v1.0/
#chmod +x run_coremark.sh
#./run_coremark.sh
#cd ../../run_dir

cp run_bw_P0P1.sh  ../9_lmbench_a9/bin/
cp run_latP0P1.sh  ../9_lmbench_a9/bin/
cp run_streamP0P1.sh ../9_lmbench_a9/bin/
cd ../9_lmbench_a9/bin/
chmod +x *.sh

./run_bw_P0P1.sh
./run_latP0P1.sh
./run_streamP0P1.sh
cd ../../run_dir
