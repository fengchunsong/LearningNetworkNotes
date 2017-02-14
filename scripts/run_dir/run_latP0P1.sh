#!/bin/bash
echo '********P0->P1 1core t***********'
numactl  --physcpubind=0 ./lat_mem_rd -P 1 -t 32m 128
echo '********P0->P1 4core t***********'       
numactl  --physcpubind=0-3 ./lat_mem_rd -P 4 -t 32m 128
echo '********P0->P1 16core  t***********'
numactl  --physcpubind=0-15 ./lat_mem_rd -P 16  -t 32m  128
echo '********P0->P1 CPU0  t************'                                                            
numactl  --physcpubind=0-31 ./lat_mem_rd -P 32 -t 32m 128

echo '********P0->P1 1core s***********'
numactl  --physcpubind=0 ./lat_mem_rd -P 1 32m 128
echo '********P0->P1 4core s***********'       
numactl  --physcpubind=0-3 ./lat_mem_rd -P 4 32m 128
echo '********P0->P1 16core  s***********'
numactl  --physcpubind=0-15 ./lat_mem_rd -P 16 32m  128
echo '********P0->P1 CPU0  s************'                                                            
numactl  --physcpubind=0-31 ./lat_mem_rd -P 32 -N 5 32m 128


echo '********P0<->P1 1core t***********'
numactl  --physcpubind=0,32 ./lat_mem_rd -P 2 -t 32m 128
echo '********P0<->P1 4core t***********'       
numactl --physcpubind=0-3,32-35 ./lat_mem_rd -P 8 -t 32m 128
echo '********P0<->P1 16core  t***********'
numactl  --physcpubind=0-15,32-47 ./lat_mem_rd -P 32  -t 32m  128
echo '********P0<->P1 CPU0  t************'                                                            
numactl  --physcpubind=0-31,32-63 ./lat_mem_rd -P 64  -t 32m 128

echo '********P0<->P1 1core s***********'
numactl --physcpubind=0,32 ./lat_mem_rd -P 2 32m 128
echo '********P0<->P1 4core s***********'       
numactl  --physcpubind=0-3,32-35 ./lat_mem_rd -P 8 32m 128
echo '********P0<->P1 16core  s***********'
numactl  --physcpubind=0-15,32-47 ./lat_mem_rd -P 32  32m 128   
echo '********P0<->P1 CPU0  s************'                                                            
numactl  --physcpubind=0-31,32-63 ./lat_mem_rd -P 64 32m 128
