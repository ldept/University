import timeit
from functools import reduce

def is_perfect(number):
    i = 1
    sum = 0
    while i < number:
        if number % i == 0:
            sum += i
        i += 1
    return sum == number


def perfect_imperative(n):
    perfects = []
    for i in range(2,n+1):
        if is_perfect(i):
            perfects.append(i)
    return perfects


def divisors(i):
    return [x for x in range(1,i // 2 + 1) if i % x == 0]

def perfect_comprehension(n):
    return [i for i in range(1,n+1) if sum(divisors(i)) == i ]



def divisors_func(num):
    return filter(lambda x: num % x == 0,range(1,num))

def perfect_function(n):
    return list(filter(lambda num: reduce(lambda x,y: x + y, divisors_func(num)) == num, range(2,n+1)))


print(perfect_function(10000))
print(perfect_comprehension(10000))
print("Skladana " + str(timeit.timeit("perfect_comprehension(1000)",setup="from __main__ import perfect_comprehension",number=100)))
print("Funkcyjna " + str(timeit.timeit("perfect_function(1000)",setup="from __main__ import perfect_function",number=100)))
print("Imperatywna " + str(timeit.timeit("perfect_imperative(1000)",setup="from __main__ import perfect_imperative",number=100)))