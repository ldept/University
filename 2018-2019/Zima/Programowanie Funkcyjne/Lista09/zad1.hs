--import Data.List

l :: [Integer]
l = [2..]

modulo :: Integer -> (Integer -> Bool)
modulo x = \y -> (y `mod` x) /= 0

f :: [Integer] -> [Integer]
f xs = [x | x <- filter (modulo (head xs)) (tail xs)]

-- f xs = [x | x <- (tail xs), (modulo (head xs)) x]



primes :: [Integer]

primes = map head (iterate f l)


-- Zad 2.
cubesmol :: Integer -> (Integer -> Bool)
cubesmol x = \y -> y^2 <= x

modulo' :: Integer -> (Integer -> Bool)
modulo' x = \y -> (x `mod` y) /= 0

primes' :: [Integer]
primes' = 2 : [x | x <- [3..], all (modulo' x) (takeWhile (cubesmol x) primes')]

-- Zad 3.
fibs :: [Integer]
fibs = 1 : 1 : zipWith (+) fibs (tail fibs)

-- Zad 5.

sublists :: [a] -> [[a]]

sublists [] = [[]]
sublists (x:xs) = [x:sublist | sublist <- a] ++ a 
                  where a = sublists xs

select [] = []
select (x:xs) = (x,xs):(map (\(y,ys) -> (y,x:ys)) (select xs))

insert :: a -> [a] -> [[a]]
insert a [] = [[a]]
insert a (x:xs) = (a:x:xs):(x:a:xs):(map (\[[y]] -> [x:[y]]) (insert a xs))

sperm [] = [[]]
sperm xs = [ y:zs | (y,ys) <- select xs, zs <- sperm ys]
