-- Łukasz Deptuch, 300771
import Prelude hiding(concat, and, all, maximum, transform)
import Data.Char (digitToInt) -- do zadania 4


-- Zadanie 1

-- insert xs inbetween yss' lists
intercalate :: [a] -> [[a]] -> [a]
intercalate xs []       = [] 
intercalate xs [ys]     = ys
intercalate xs (ys:yss) = ys ++ xs ++ (intercalate xs yss)

transpose :: [[a]] -> [[a]]
transpose ([]:_) = []
transpose x = (map head x) : transpose (map tail x)

concat :: [[a]] -> [a]
concat []       = []
concat [x]      = x
concat (xs:xss) = xs ++ (concat xss)

and :: [Bool] -> Bool
and xs = foldr (\x acc -> acc && x) True xs

all :: (a -> Bool) -> [a] -> Bool
all f xs = foldr (\x acc -> acc && f x) True xs

maximum :: [Integer] -> Integer
maximum = foldr1 (\x y -> if x >= y then x else y) 



-- Zadanie 2
newtype Vector a = Vector { fromVector :: [a] }

scaleV :: Num a => a -> Vector a -> Vector a
scaleV a vec = Vector(map ((*) a)  (fromVector vec))

norm :: Floating a => Vector a -> a
norm vec = sqrt $ foldr (\x acc -> acc + x**2) 0 (fromVector vec)

scalarProd :: Num a => Vector a -> Vector a -> a
scalarProd (Vector [])     (Vector [])     = 0
scalarProd (Vector [x])    (Vector [])     = error "zly rozmiar"
scalarProd (Vector [])     (Vector [y])    = error "zly rozmiar"
scalarProd (Vector (x:xs)) (Vector (y:ys)) = x*y + scalarProd (Vector xs) (Vector ys) 

sumV :: Num a => Vector a -> Vector a -> Vector a
sumV (Vector [])     (Vector [])     = Vector []
sumV (Vector [x])    (Vector [])     = error "zly rozmiar"
sumV (Vector [])     (Vector [y])    = error "zly rozmiar"
sumV (Vector (x:xs)) (Vector (y:ys)) = Vector $ (x+y) : fromVector( sumV (Vector xs) (Vector ys))


-- Zadanie 3
newtype Matrix a = Matrix { fromMatrix :: [[a]] }

sumM :: Num a => Matrix a -> Matrix a -> Matrix a
sumM (Matrix [])       (Matrix [])       = Matrix []
sumM (Matrix [xs])     (Matrix [])       = error "zly rozmiar"
sumM (Matrix [])       (Matrix [ys])     = error "zly rozmiar"
sumM (Matrix (xs:xss)) (Matrix (ys:yss)) = Matrix $ row : (fromMatrix (sumM (Matrix xss) (Matrix yss))) where
    row = zipWith (+) xs ys

prodM :: Num a => Matrix a -> Matrix a -> Matrix a
prodM (Matrix [])       (Matrix [])       = Matrix []
prodM (Matrix [xs])     (Matrix [])       = undefined
prodM (Matrix [])       (Matrix [ys])     = undefined
prodM (Matrix xss) (Matrix yss) =  Matrix([[ sum $ zipWith (*) xs ys | ys <- (transpose yss) ] | xs <- xss] )
    
t1 = fromMatrix $ prodM (Matrix [[1,2,3], [4,5,6]]) (Matrix [[7,8], [9,10], [11,12]])
-- Zadanie 4
isbn13_check :: String -> Bool
isbn13_check str =  (sum nums_even_index + sum nums_odd_index) `mod` 10 == 0  where
    nums            = map digitToInt $ filter (/= '-') str -- transform string to list of digits
    nums_with_index = zip [x | x <- [0..12]] nums
    nums_even_index = [ x | (i,x) <- nums_with_index, i `mod` 2 == 0 ]
    nums_odd_index  = [ 3*x | (i,x) <- nums_with_index, i `mod` 2 /= 0 ]


-- Zadanie 5
newtype Natural = Natural { fromNatural :: [Word] }

base :: Word
base = 4294967296

 