#!/usr/bin/env bash
solvers="cbc couenne ipopt cplex baron"
for solver in $solvers
do
    echo "Solver: $solver"
    cmd="pyomo solve opt_pyomo/svm.py opt_pyomo/svm.dat --solver=$solver --solver-manager=neos"
    echo "$cmd" > opt_pyomo/${solver}_out.txt
    $cmd 2>&1 >> opt_pyomo/${solver}_out.txt
    mv results.yml opt_pyomo/${solver}_results.yml
done