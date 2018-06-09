from pyomo.environ import *

model = AbstractModel()

model.n = Param(within=NonNegativeIntegers)
model.m = Param(within=NonNegativeIntegers)

model.I = RangeSet(1, model.n)
model.J = RangeSet(1, model.m)

model.X = Param(model.I, model.J)
model.y = Param(model.I)
model.l = Param()
model.ksis = Var(model.I, domain=NonNegativeReals)
model.b = Var()
model.w = Var(model.J)


def obj_expression(model):
    return sum(model.ksis[i] for i in model.I) + model.l * model.n * sum(model.w[j]**2 for j in model.J)


model.OBJ = Objective(rule=obj_expression, sense=minimize)


def constI(model, i):
    return model.y[i] * (sum(model.w[j] * model.X[i,j] for j in model.J) + model.b) >= 1 - model.ksis[i]


model.c1 = Constraint(model.I, rule=constI)
