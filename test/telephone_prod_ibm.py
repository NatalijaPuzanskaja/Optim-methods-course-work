# first import the Model class from docplex.mp
from docplex.mp.model import Model

# Created Jun 10, 2018, 9:11 PM
url = 'https://api-oaas.docloud.ibmcloud.com/job_manager/rest/v1/'
key = 'api_385e24bd-0382-42d5-99db-59579269cbb9'

# create one model instance, with a name
m = Model(name='telephone_production')

# by default, all variables in Docplex have a lower bound of 0 and infinite upper bound
desk = m.continuous_var(name='desk')
cell = m.continuous_var(name='cell')

# write constraints
# constraint #1: desk production is greater than 100
m.add_constraint(desk >= 100)

# constraint #2: cell production is greater than 100
m.add_constraint(cell >= 100)

# constraint #3: assembly time limit
ct_assembly = m.add_constraint(0.2 * desk + 0.4 * cell <= 400)

# constraint #4: paiting time limit
ct_painting = m.add_constraint(0.5 * desk + 0.4 * cell <= 490)

m.maximize(12 * desk + 20 * cell)

m.print_information()

s = m.solve(url=url, key=key)
m.print_solution()
