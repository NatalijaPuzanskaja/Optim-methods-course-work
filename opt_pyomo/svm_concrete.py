import numpy as np

from pyomo.environ import *


def build_model():
    model = ConcreteModel()

    model.n = 6
    model.m = 2

    model.I = RangeSet(1, model.n)
    model.J = RangeSet(1, model.m)

    D = np.matrix([[4, 6], [5, 5], [6, 3], [0, 0], [1, 2], [4, 0]])
    X_init = dict(((i, j), D[i-1, j-1]) for i in model.I for j in model.J)
    model.X = Param(model.I, model.J, initialize=X_init)

    model.y = Param(model.I, initialize={1: 1, 2: 1, 3: 1, 4: 0, 5: 0, 6: 0})

    model.l = 0.01

    model.ksis = Var(model.I, domain=NonNegativeReals)
    model.b = Var()
    model.w = Var(model.J)

    def obj_expression(model):
        return sum(model.ksis[i] for i in model.I) + model.l * model.n * sum(model.w[j]**2 for j in model.J)
    model.obj = Objective(rule=obj_expression, sense=minimize)

    def const_expression(model, i):
        return model.y[i] * (sum(model.w[j] * model.X[i, j] for j in model.J) + model.b) >= 1 - model.ksis[i]
    model.c1 = Constraint(model.I, rule=const_expression)

    return model


if __name__ == '__main__':
    instance = build_model()
    opt = SolverFactory("ipopt")
    solver_manager = SolverManagerFactory('neos')
    results = solver_manager.solve(instance, opt=opt)

    print(results)
