#!/usr/bin/env bash
cmd="pyomo solve --solver=ipopt --summary test/rosenbrock.py"
echo "$cmd" > test/rosenbrock_ipopt_out.txt
$cmd 2>&1 >> test/rosenbrock_ipopt_out.txt
mv results.yml test/rosenbrock_ipopt_results.yml