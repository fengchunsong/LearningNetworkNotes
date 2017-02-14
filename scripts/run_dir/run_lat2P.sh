#!/bin/bash
echo '********2P 1core t***********'
numactl --membind=0 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 -t 32M 128

echo '********2P 1core s***********'
numactl --membind=0 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 32M 128

echo '********2P TA->TC 1core t***********'
numactl --membind=1 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 -t 32M 128

echo '********2P  TA->TC 1core s***********'
numactl --membind=1 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 32M 128



//P0->P1
echo '********P0TA->P1TA  1core t***********'
numactl --membind=2 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 -t 32M 128

echo '********2P  P0TA->P1TA  1core s***********'
numactl --membind=2 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 32M 128

echo '********P0TB->P1TB  1core t***********'
numactl --membind=3 --physcpubind=16 ./lat_mem_rd -P 1 -N 5  -t 32M 128

echo '********2P  P0TB->P1TB  1core s***********'
numactl --membind=3 --physcpubind=16 ./lat_mem_rd -P 1 -N 5 32M 128


