\begin{code}

import Data.List(unfoldr)

explode :: Integer -> [Integer]
explode 0 = [0]
explode n = reverse $ unfoldr digit n where
    digit 0 = Nothing
    digit k = Just (k `mod` 10, k `div` 10)

implode :: [Integer] -> Integer
implode = foldl (\n m -> n * 10 + m) 0

inits' :: [a] -> [[a]]
inits' [] = [[]]
inits' (x:xs) = [] : (map (x:)  $ inits' xs)


tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xxs@(_:xs) = xxs : tails' xs

elem' :: Eq a => a -> [a] -> Bool
elem' e xs = foldr (\x acc -> acc || e == x ) False xs


intersperse :: a -> [a] -> [a]
intersperse s [] = []
intersperse s [x] = [x]
intersperse s (x:xs) = x : s : (intersperse s xs)

qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort [y | y <- xs, y < x] ++ [x] ++ qsort [y | y <- xs, y >= x]

\end{code}