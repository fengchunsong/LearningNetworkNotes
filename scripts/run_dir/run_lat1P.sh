#!/bin/bash
echo '********1core t***********'
numactl --membind=0 --physcpubind=0 ./lat_mem_rd -P 1  -t 32M 128
echo '********4core t***********'       
numactl --membind=0 --physcpubind=0-3 ./lat_mem_rd -P 4  -t 32M  128
echo '********16core  t***********'
numactl --membind=0 --physcpubind=0-15 ./lat_mem_rd -P 16 -t 32M  128
echo '********CPU0  t************'                                                            
numactl  --physcpubind=0-31 ./lat_mem_rd -P 32 -t 32M 128

echo '********1core s***********'
numactl --membind=0 --physcpubind=0 ./lat_mem_rd -P 1 32M 128
echo '********4core s***********'       
numactl --membind=0 --physcpubind=0-3 ./lat_mem_rd -P 4  32M 128
echo '********16core  s***********'
numactl --membind=0 --physcpubind=0-15 ./lat_mem_rd -P 16 32M  128
echo '********CPU0  s************'                                                            
numactl --physcpubind=0-31 ./lat_mem_rd -P 32 32M  128


echo '********1P TA->TC 1core t***********'
numactl --membind=1 --physcpubind=0 ./lat_mem_rd -P 1 -t 32M  128
echo '********1P  TA->TC 4core t***********'       
numactl --membind=1 --physcpubind=0-3 ./lat_mem_rd -P 4 -t 32M 128
echo '********1P  TA->TC 16core  t***********'
numactl --membind=1 --physcpubind=0-15 ./lat_mem_rd -P 16 -t 32M 128

echo '********1P  TA->TC 1core s***********'
numactl --membind=1 --physcpubind=0 ./lat_mem_rd -P 1 32M 128
echo '********1P  TA->TC 4core s***********'       
numactl --membind=1 --physcpubind=0-3 ./lat_mem_rd -P 4 32M 128
echo '********1P  TA->TC 16core  s***********'
numactl --membind=1 --physcpubind=0-15 ./lat_mem_rd -P 16 32M 128
