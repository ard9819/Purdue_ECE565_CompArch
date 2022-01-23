#!/bin/bash

#declare -a benchmark=("bzip2" "cactusADM" "hmmer" "mcf" "sphinx3")
declare -a benchmark=("hmmer" "sphinx3")
declare -a l3_assoc=("8" "32")
run_num=run_3_L3_Assoc_81632
policy=lru

for bench in "${benchmark[@]}"; do
	for l3assoc in "${l3_assoc[@]}"; do
		./build/X86/gem5.opt -d $run_num/$l3assoc/$bench/$policy configs/spec2k6/run.py --benchmark=$bench --maxinsts=250000000 --cpu-type=DerivO3CPU --caches --l2cache --l3cache --fast-forward=1000000000 --warmup-insts=50000000 --standard-switch=50000000 --caches --l2cache --l3cache --l3_assoc=$l3assoc --l3_replacement_policy=$policy
	done
done

wait
