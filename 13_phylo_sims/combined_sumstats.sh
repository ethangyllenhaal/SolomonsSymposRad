#!/bin/bash

> sumstat.txt

parallel -j 1 \
        'paste <(echo -e "{1}\t{2}\t{3}\t{4}\t{5}\t{6}") <(tail -n1 output/sim/archsim_d{1}_n{2}_t{3}_i{4}_{5}_r{6}_stats.txt) >> sumstat.txt' \
              ::: 0.000001 10 15 20 30 40 50 60 ::: 50000 100000 ::: 200000 400000 800000 1600000 ::: 50000 100000 200000 ::: mak buk ::: {1..10}

