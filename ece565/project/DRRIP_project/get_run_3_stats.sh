#! /bin/bash

#File to compile results from the stats.txt file

#declare -a benchmark=("bzip2" "cactusADM" "hmmer" "mcf" "sphinx3")
declare -a benchmark=("hmmer" "sphinx3")
declare -a repl=("lru" "srrip" "brrip" "drrip")
declare -a l3_assoc=("8" "16" "32")
run_num=run_3_L3_Assoc_81632

for bench in "${benchmark[@]}"; do
	echo "--------------------------------------"
	echo "--------------- $bench ---------------"
	echo "--------------------------------------"
	for l3assoc in "${l3_assoc[@]}"; do
		echo "--------------- $l3assoc ---------------"
		echo "Policy, Icache misses, Dcache misses, L2 misses, L3 misses, IPC"
		for policy in "${repl[@]}"; do
			ipc=`cat $run_num/$l3assoc/$bench/$policy/stats.txt | grep switch_cpus_1.ipc | tail -1 | awk -F" " '{print $2}'`
			icache_miss=`cat $run_num/$l3assoc/$bench/$policy/stats.txt | grep icache.demand_misses::.switch_cpus_1 | awk -F" " '{print $2}'`
			dcache_miss=`cat $run_num/$l3assoc/$bench/$policy/stats.txt | grep dcache.demand_misses::.switch_cpus_1 | awk -F" " '{print $2}'`
			l2_miss=`cat $run_num/$l3assoc/$bench/$policy/stats.txt     | grep l2.demand_misses::.switch_cpus_1.data | awk -F" " '{print $2}'`
			l3_miss=`cat $run_num/$l3assoc/$bench/$policy/stats.txt     | grep l3.demand_misses::.switch_cpus_1.data | awk -F" " '{print $2}'`
			echo $policy, $icache_miss, $dcache_miss, $l2_miss, $l3_miss, $ipc 
		done
	done
done
