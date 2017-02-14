#!/bin/bash
echo 'P0->P1 local'
echo 'P0->P1 1core'
taskset -c 0 ./stream -P 1 -N 5 -W 5 -M 32M
echo 'P0->P1 1clu'
taskset -c 0-3 ./stream -P 4 -N 5 -W 5 -M 32M
echo 'P0->P1 1tot'
taskset -c 0-15 ./stream -P 16 -N 5 -W 5 -M 32M
echo 'P0->P1 1cpu'
taskset -c 0-31 ./stream -P 32 -N 5 -W 5 -M 32M

echo 'P0<->P1 1core'
taskset -c 0,32 ./stream -P 2 -N 5 -W 5 -M 32M
echo 'P0<->P1 1clu'
taskset -c 0-3,32-35 ./stream -P 8 -N 5 -W 5 -M 32M
echo 'P0<->P1 1tot'
taskset -c 0-15,32-47 ./stream -P 32 -N 5 -W 5 -M 32M
echo 'P0<->P1 1cpu'
taskset -c 0-31,32-63 ./stream -P 64 -N 5 -W 5 -M 32M

