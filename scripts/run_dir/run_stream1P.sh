#!/bin/bash
echo '1core'
taskset -c 0 ./stream -P 1 -N 5 -W 5 -M 32M
echo '1clu'
taskset -c 0-3 ./stream -P 4 -N 5 -W 5 -M 32M
echo '1tot'
taskset -c 0-15 ./stream -P 16 -N 5 -W 5 -M 32M
echo '1cpu'
taskset -c 0-31 ./stream -P 32 -N 5 -W 5 -M 32M
