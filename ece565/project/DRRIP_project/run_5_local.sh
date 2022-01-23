
cd ece565/project/gem5_org/

./build/X86/gem5.opt -d run_5_Final_Benchmarks_run/namd/lru configs/spec2k6/run.py --benchmark=namd --maxinsts=250000000 --cpu-type=DerivO3CPU --caches --l2cache --l3cache --fast-forward=1000000000 --warmup-insts=50000000 --standard-switch=50000000 --caches --l2cache --l3cache --l3_replacement_policy=lru

./build/X86/gem5.opt -d run_5_Final_Benchmarks_run/namd/srrip configs/spec2k6/run.py --benchmark=namd --maxinsts=250000000 --cpu-type=DerivO3CPU --caches --l2cache --l3cache --fast-forward=1000000000 --warmup-insts=50000000 --standard-switch=50000000 --caches --l2cache --l3cache --l3_replacement_policy=srrip

./build/X86/gem5.opt -d run_5_Final_Benchmarks_run/namd/brrip configs/spec2k6/run.py --benchmark=namd --maxinsts=250000000 --cpu-type=DerivO3CPU --caches --l2cache --l3cache --fast-forward=1000000000 --warmup-insts=50000000 --standard-switch=50000000 --caches --l2cache --l3cache --l3_replacement_policy=brrip

./build/X86/gem5.opt -d run_5_Final_Benchmarks_run/namd/drrip configs/spec2k6/run.py --benchmark=namd --maxinsts=250000000 --cpu-type=DerivO3CPU --caches --l2cache --l3cache --fast-forward=1000000000 --warmup-insts=50000000 --standard-switch=50000000 --caches --l2cache --l3cache --l3_replacement_policy=drrip

