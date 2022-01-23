#!/bin/bash

#declare -a benchmark=("bzip2" "cactusADM" "hmmer" "mcf" "sphinx3")
declare -a benchmark=("hmmer" "sphinx3" "cactusADM")
declare -a l3_size=("1MB" "2MB" "4MB")
declare -a l3_assoc=("8" "16" "32")
run_num=run_2_L3_Size_124
policy=brrip

for bench in "${benchmark[@]}"; do
	for l3size in "${l3_size[@]}"; do
		./build/X86/gem5.opt -d $run_num/$l3size/$bench/$policy configs/spec2k6/run.py --benchmark=$bench --maxinsts=250000000 --cpu-type=DerivO3CPU --caches --l2cache --l3cache --fast-forward=1000000000 --warmup-insts=50000000 --standard-switch=50000000 --caches --l2cache --l3cache --l3_size=$l3size --l3_replacement_policy=$policy
	done
done

wait
