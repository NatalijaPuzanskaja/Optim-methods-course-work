#!/usr/bin/env bash
solvers="glpk minos bonmin cbc scip couenne gecode ipopt jacob"
for solver in $solvers
do
    echo "Solver: $solver"
    cmd="pyomo solve svm/svm_pyomo.py svm/data/svm_pyomo.dat --solver=$solver"
    echo "$cmd" > svm/results/${solver}_out.txt
    $cmd 2>&1 >> svm/results/${solver}_out.txt
    mv results.json svm/results/${solver}_results.json
done