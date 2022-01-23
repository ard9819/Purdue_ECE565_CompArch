#!/bin/bash

#declare -a benchmark=("hmmer" "sphinx3" "cactusADM" "mcf" "bzip2" "astar" "namd" "sjeng")
#declare -a benchmark=("hmmer" "sphinx3" "cactusADM" "mcf" "bzip2")
declare -a benchmark=("hmmer" "sphinx3" "cactusADM" "mcf")

#declare -a repl=("srrip" "brrip" "drrip")
declare -a repl=("srrip")

run_num=run_1_HP_FP_M234

build_and_run_gem5(){
	sed -i '79s/.*/''    num_bits = Param.Int('"$1"', "Number of bits per RRPV")/g' /home/min/a/jain490/ece565/project/gem5_org/src/mem/cache/replacement_policies/ReplacementPolicies.py
	sed -i '80s/.*/''    hit_priority = Param.Bool('"$2"',/g' /home/min/a/jain490/ece565/project/gem5_org/src/mem/cache/replacement_policies/ReplacementPolicies.py

	scons-3 -j 4 ./build/X86/gem5.opt

	for bench in "${benchmark[@]}"; do
		for policy in "${repl[@]}"; do
			./build/X86/gem5.opt -d $run_num/M$1_HP$2/$policy/$bench configs/spec2k6/run.py --benchmark=$bench --maxinsts=250000000 --cpu-type=DerivO3CPU --caches --l2cache --l3cache --fast-forward=1000000000 --warmup-insts=50000000 --standard-switch=50000000 --caches --l2cache --l3cache --l3_replacement_policy=$policy
		done
	done
}

build_and_run_gem5 2 False
build_and_run_gem5 2 True

build_and_run_gem5 3 False
build_and_run_gem5 3 True

#build_and_run_gem5 4 False
#build_and_run_gem5 4 True


get_stats(){
	echo "------------------------------ M=$1 HP=$2 ------------------------------"
	for bench in "${benchmark[@]}"; do
		echo "--------------- $bench ---------------"
		echo "Policy, Icache misses, Dcache misses, L2 misses, L3 misses, IPC"
		for policy in "${repl[@]}"; do
			ipc=`cat $run_num/M$1_HP$2/$policy/$bench/stats.txt | grep switch_cpus_1.ipc | tail -1 | awk -F" " '{print $2}'`
			icache_miss=`cat $run_num/M$1_HP$2/$policy/$bench/stats.txt | grep icache.demand_misses::.switch_cpus_1 | awk -F" " '{print $2}'`
			dcache_miss=`cat $run_num/M$1_HP$2/$policy/$bench/stats.txt | grep dcache.demand_misses::.switch_cpus_1 | awk -F" " '{print $2}'`
			l2_miss=`cat $run_num/M$1_HP$2/$policy/$bench/stats.txt     | grep l2.demand_misses::.switch_cpus_1.data | awk -F" " '{print $2}'`
			l3_miss=`cat $run_num/M$1_HP$2/$policy/$bench/stats.txt     | grep l3.demand_misses::.switch_cpus_1.data | awk -F" " '{print $2}'`
			echo $policy, $icache_miss, $dcache_miss, $l2_miss, $l3_miss, $ipc 
		done
	done
}

get_stats 2 False
get_stats 2 True

get_stats 3 False
get_stats 3 True

#get_stats 4 False
#get_stats 4 True

wait

	#sed -i '92s/.*/''    num_set_dueling_sets = Param.Int('"$3"',/g' /home/min/a/jain490/ece565/project/gem5_org/src/mem/cache/replacement_policies/ReplacementPolicies.py
	#sed -i '94s/.*/''    num_PSEL_counter_bits = Param.Int('"$4"',/g' /home/min/a/jain490/ece565/project/gem5_org/src/mem/cache/replacement_policies/ReplacementPolicies.py

