#! /bin/bash

#File to compile results from the stats.txt file

declare -a benchmark=("sphinx3" "cactusADM" "hmmer" "bzip2" "mcf")
declare -a repl=("lru" "srrip" "brrip" "drrip")
run_num=run_4_Final_Benchmarks_run

echo "" > run_4_stats.csv

for policy in "${repl[@]}"; do
	for bench in "${benchmark[@]}"; do
		echo "--------------- $bench ---------------"
		echo "Policy, Icache misses, Dcache misses, L2 misses, L3 misses, IPC"
		ipc=`cat $run_num/$bench/$policy/stats.txt | grep switch_cpus_1.ipc | tail -1 | awk -F" " '{print $2}'`
		icache_miss=`cat $run_num/$bench/$policy/stats.txt | grep icache.demand_misses::.switch_cpus_1 | awk -F" " '{print $2}'`
		dcache_miss=`cat $run_num/$bench/$policy/stats.txt | grep dcache.demand_misses::.switch_cpus_1 | awk -F" " '{print $2}'`
		l2_miss=`cat $run_num/$bench/$policy/stats.txt     | grep l2.demand_misses::.switch_cpus_1.data | awk -F" " '{print $2}'`
		l3_miss=`cat $run_num/$bench/$policy/stats.txt     | grep l3.demand_misses::.switch_cpus_1.data | awk -F" " '{print $2}'`
		echo $policy, $icache_miss, $dcache_miss, $l2_miss, $l3_miss, $ipc 
		echo $bench >> run_4_stats.csv
		echo $policy, $l3_miss, $ipc >> run_4_stats.csv
	done
done
