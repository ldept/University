import itertools

class Formula:
    def get_variables(self, formula):
        variables = []
        if isinstance(formula, Variable):
            variables.append(formula.name)
        elif isinstance(formula, Not):
            variables += self.get_variables(formula.expression)
        elif not( isinstance(formula,Richtig) or isinstance(formula, Falsch) ):
            variables += self.get_variables(formula.left_operator)
            variables += self.get_variables(formula.right_operator)

        return variables


    def get_values_tuples(self, nr_of_variables):
        return list(itertools.product([True,False],repeat=nr_of_variables))
    
    
    #def calculate(self,variables):
    #    pass

    
    def tautology(self):
        variables = self.get_variables(self)
        values_tuples = self.get_values_tuples(len(variables))
        for values in values_tuples:
            if self.calculate(dict(zip(variables,list(values)))):
                return True
        return False
        

class Falsch(Formula):

    def __str__(self):
        return 'false'
    def calculate(self,variables):
        return False


class Richtig(Formula):

    def __str__(self):
        return 'true'
    def calculate(self,variables):
        return True


class Variable(Formula):
    def __init__(self,variable):
        self.name = variable
    def __str__(self):
        return self.name
    def calculate(self,variables):
        if self.name in variables:
            return variables[self.name]
        else:
            pass

class Not(Formula):
    def __init__(self, expression):
        self.expression = expression
        
    def __str__(self):
        return f'¬({self.expression})'
    def calculate(self,variables):
        return not self.expression.calculate(variables)

class And(Formula):
    def __init__(self, left_operator, right_operator):
        self.left_operator = left_operator
        self.right_operator = right_operator
    
    def __str__(self):
        return f'({self.left_operator} ∧ {self.right_operator})'
    def calculate(self, variables):
        return self.left_operator.calculate(variables) and self.right_operator.calculate(variables)

class Implication(Formula):
    def __init__(self, left_operator, right_operator):
        self.left_operator = left_operator
        self.right_operator = right_operator
    
    def __str__(self):
        return f'({self.left_operator} → {self.right_operator})'
    def calculate(self, variables):
        if self.left_operator.calculate(variables) and not self.right_operator.calculate(variables):
            return False
        else:
            return True

class Or(Formula):
    def __init__(self, left_operator, right_operator):
        self.left_operator = left_operator
        self.right_operator = right_operator
    
    def __str__(self):
        return f'({self.left_operator} ∨ {self.right_operator})'
    def calculate(self, variables):
        return self.left_operator.calculate(variables) or self.right_operator.calculate(variables)

class IFF(Formula):
    def __init__(self, left_operator, right_operator):
        self.left_operator = left_operator
        self.right_operator = right_operator
    
    def __str__(self):
        return f'({self.left_operator} = {self.right_operator})'
    def calculate(self, variables):
        return (self.left_operator.calculate(variables) and self.right_operator.calculate(variables)) or (not self.left_operator.calculate(variables) and not self.right_operator.calculate(variables))


print(Implication(Variable('x'), And(Variable('y'), Richtig())))
print(Implication(Variable('x'), And(Variable('y'), Richtig())).calculate(variables = {'x' : True, 'y' : False}))
print(Or(Variable('x'), Not(Variable('x'))), Or(Variable('x'), Not(Variable('x'))).tautology())
