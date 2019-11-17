import timeit
from functools import reduce
from math import floor
from math import sqrt

def is_prime(number):
    if number == 2:
        return True
    i = 2
    while i * i <= number:
        if number % i == 0:
            return False
        i += 1
    return True

def prime_comprehension(n):
    return [i for i in range(2,n+1) if all(i % dzielnik != 0 for dzielnik in range(2,floor(sqrt(i))+1))]#if is_prime(i)]

def prime_imperative(n):
    primes = []
    for i in range(2,n+1):
        if is_prime(i):
            primes.append(i)
    return primes

def divisors_func(num):
    return list(filter(lambda x: num % x == 0, range(2,floor(sqrt(num))+1)))
def prime_function(n):
    # return list(filter(, list(range(2,n+1))))
    # return filter(lambda x : filter(,divisors(x)) == divisors(x) , range(2,n+1))
    return list(filter(lambda x: len(divisors_func(x)) == 0, range(2,n+1))) #lambda x : all(x % divisor != 0 for divisor in divisors_func(x)) , range(2,n+1)))


# print( list(reduce(lambda a,b: a and b, map(lambda divisor: x % divisor != 0, divisors_func(x)))))

print(prime_comprehension(20))
print(prime_function(20))
print(prime_imperative(20))

print(timeit.timeit("prime_comprehension(2000)",setup="from __main__ import prime_comprehension",number=100))
print(timeit.timeit("prime_function(2000)",setup="from __main__ import prime_function",number=100))
print(timeit.timeit("prime_imperative(2000)",setup="from __main__ import prime_imperative",number=100))