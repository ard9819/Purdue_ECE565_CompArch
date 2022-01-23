#!/bin/bash

#declare -a benchmark=("hmmer" "sphinx3" "cactusADM" "mcf" "bzip2" "astar" "namd" "sjeng")
#declare -a benchmark=("hmmer" "sphinx3" "cactusADM" "mcf" "bzip2")
declare -a benchmark=("hmmer" "sphinx3" "cactusADM" "mcf")

#declare -a repl=("srrip" "brrip" "drrip")
declare -a repl=("srrip")

run_num=run_1_HP_FP_M234

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

