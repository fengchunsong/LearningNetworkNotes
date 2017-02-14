#!/bin/bash
echo '********2P 1core t***********'
numactl --membind=0 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 -t 32M 128
echo '********2P 4core t***********'       
numactl --membind=0 --physcpubind=0-3 ./lat_mem_rd -P 4 -N 5 -t 32M 128
echo '********2P 16core  t***********'
numactl --membind=0 --physcpubind=0-15 ./lat_mem_rd -P 16  -N 5 -t 32M  128
echo '********2P CPU0  t************'                                                            
numactl  --physcpubind=0-31 ./lat_mem_rd -P 32 -N 5 -t 32M 128
echo '********2P CPU12  t************'                                                            
numactl  --physcpubind=0-63 ./lat_mem_rd -P 64 -N 5 -t 32M 128

echo '********2P 1core s***********'
numactl --membind=0 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 32M 128
echo '********2P 4core s***********'       
numactl --membind=0 --physcpubind=0-3 ./lat_mem_rd -P 4  -N 5 32M 128
echo '********2P 16core  s***********'
numactl --membind=0 --physcpubind=0-15 ./lat_mem_rd -P 16  -N 5 32M  128
echo '********2P CPU0  s************'                                                            
numactl  --physcpubind=0-31 ./lat_mem_rd -P 32  -N 5 32M 128
echo '********2P CPU12  s************'                                                            
numactl  --physcpubind=0-63 ./lat_mem_rd -P 64  -N 5 32M 128

echo '********2P TA->TC 1core t***********'
numactl --membind=1 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 -t 32M 128
echo '********2P  TA->TC 4core t***********'       
numactl --membind=1 --physcpubind=0-3 ./lat_mem_rd -P 4 -N 5 -t 32M 128
echo '********2P  TA->TC 16core  t***********'
numactl --membind=1 --physcpubind=0-15 ./lat_mem_rd -P 16  -N 5 -t 32M  128

echo '********2P  TA->TC 1core s***********'
numactl --membind=1 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 32M 128
echo '********2P  TA->TC 4core s***********'       
numactl --membind=1 --physcpubind=0-3 ./lat_mem_rd -P 4  -N 5 32M 128
echo '********2P  TA->TC 16core  s***********'
numactl --membind=1 --physcpubind=0-15 ./lat_mem_rd -P 16  -N 5 32M  128


//po->P1
echo '********P0TA->P1TA  1core t***********'
numactl --membind=2 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 -t 32M 128
echo '********P0TA->P1TA  4core t***********'       
numactl --membind=2 --physcpubind=0-3 ./lat_mem_rd -P 4 -N 5 -t 32M 128
echo '********P0TA->P1TA  16core  t***********'
numactl --membind=2 --physcpubind=0-15 ./lat_mem_rd -P 16 -N 5 -t 32M  128

echo '********2P  P0TA->P1TA  1core s***********'
numactl --membind=2 --physcpubind=0 ./lat_mem_rd -P 1 -N 5 32M 128
echo '********2P  P0TA->P1TA  4core s***********'       
numactl --membind=2 --physcpubind=0-3 ./lat_mem_rd -P 4 -N 5 32M 128
echo '********2P  P0TA->P1TA  16core  s***********'
numactl --membind=2 --physcpubind=0-15 ./lat_mem_rd -P 16 -N 5 32M  128


echo '********P0TB->P1TB  1core t***********'
numactl --membind=3 --physcpubind=16 ./lat_mem_rd -P 1 -N 5  -t 32M 128
echo '********P0TB->P1TB    4core t***********'       
numactl --membind=3 --physcpubind=16-19 ./lat_mem_rd -P 4 -N 5 -t 32M 128
echo '********P0TB->P1TB  ->TC 16core  t***********'
numactl --membind=3 --physcpubind=16-31 ./lat_mem_rd -P 16 -N 5 -t 32M  128

echo '********2P  P0TB->P1TB  1core s***********'
numactl --membind=3 --physcpubind=16 ./lat_mem_rd -P 1 -N 5 32M 128
echo '********2P  P0TB->P1TB  4core s***********'       
numactl --membind=3 --physcpubind=16-19 ./lat_mem_rd -P 4 -N 5 32M 128
echo '********2P  P0TB->P1TB 16core  s***********'
numactl --membind=3 --physcpubind=16-31 ./lat_mem_rd -P 16 -N 5 32M 128

