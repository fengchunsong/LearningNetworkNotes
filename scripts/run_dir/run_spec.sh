#!/bin/bash
taskset -c 0 ./runspec -c ../config/core0_1616.cfg  all --rate 1 -n 3 --noreportable --nobuild
taskset -c 0-31 ./runspec -c ../config/cpu_1616.cfg  all --rate 1 -n 3 --noreportable --nobuild
taskset -c 0-63 ./runspec -c ../config/all_1616.cfg  all --rate 1 -n 3 --noreportable --nobuild
