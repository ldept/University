-- Łukasz Deptuch,
-- Lista 01, 10.03.2020

import Prelude hiding(concat, and, all, maximum, transform)
import Data.Char (digitToInt) -- do zadania 4
import Data.Function (on)

-- Zadanie 1

-- insert xs inbetween yss' lists
intercalate :: [a] -> [[a]] -> [a]
intercalate xs []       = [] 
intercalate xs [ys]     = ys
intercalate xs (ys:yss) = ys ++ xs ++ (intercalate xs yss)

transpose :: [[a]] -> [[a]]
transpose [] = []
transpose x = (map head x) : transpose (filter (not . null) (map tail x))

concat :: [[a]] -> [a]
concat []       = []
concat [x]      = x
concat (xs:xss) = xs ++ (concat xss)

and :: [Bool] -> Bool
and xs = foldr (&&) True xs --foldl'

all :: (a -> Bool) -> [a] -> Bool
all f xs = foldr (\x acc -> acc && f x) True xs
        -- flip foldr True . (flip (&&) .)

maximum :: [Integer] -> Integer
maximum xs = foldr1 max xs



-- Zadanie 2
newtype Vector a = Vector { fromVector :: [a] }

scaleV :: Num a => a -> Vector a -> Vector a
scaleV a vec = Vector $ map (a *) $ fromVector vec

norm :: Floating a => Vector a -> a
norm vec = sqrt $ foldr (\x acc -> acc + x**2) 0 $ fromVector vec -- sum . map(**2)

scalarProd :: Num a => Vector a -> Vector a -> a
scalarProd (Vector [])     (Vector [])     = 0
scalarProd (Vector [x])    (Vector [])     = error "zly rozmiar"
scalarProd (Vector [])     (Vector [y])    = error "zly rozmiar"
scalarProd (Vector (x:xs)) (Vector (y:ys)) = x*y + scalarProd (Vector xs) (Vector ys) 

sumV :: Num a => Vector a -> Vector a -> Vector a
sumV (Vector [])     (Vector [])     = Vector []
sumV (Vector [x])    (Vector [])     = error "zly rozmiar"
sumV (Vector [])     (Vector [y])    = error "zly rozmiar"
sumV (Vector (x:xs)) (Vector (y:ys)) = Vector $ (x+y) : fromVector (sumV (Vector xs) (Vector ys))


-- Zadanie 3    
newtype Matrix a = Matrix { fromMatrix :: [[a]] }

sumM :: Num a => Matrix a -> Matrix a -> Matrix a
sumM (Matrix [])          (Matrix [])          = Matrix []
sumM m1@(Matrix (xs:xss)) m2@(Matrix (ys:yss)) = if is_correct_size 
                                                 then Matrix $ row : (fromMatrix (sumM (Matrix xss) (Matrix yss))) 
                                                 else error "size mismatch" where
    row = zipWith (+) xs ys
    is_correct_size = sizeM m1 == sizeM m2

prodM :: Num a => Matrix a -> Matrix a -> Matrix a
prodM    (Matrix [])     (Matrix [])       = Matrix []
prodM m1@(Matrix xss) m2@(Matrix yss)      
    |   is_correct_size = Matrix $ [ [ sum $ zipWith (*) xs ys | ys <- (transpose yss) ] | xs <- xss]
    |   otherwise       = error "size mismatch" where
        
        is_correct_size =   all_equal m1_size_list 
                            && all_equal m2_size_list
                            && are_multiplicable m1_size_list m2_size_list
        m1_size_list = sizeM m1
        m2_size_list = sizeM m2
        all_equal [x,y] = x == y -- check if all rows are of equal lengths
        all_equal (x:y:xs) = x == y && all_equal (y:xs)
        are_multiplicable m1 m2 = head m1 == length m2



sizeM :: Matrix a -> [Int]
sizeM (Matrix []) = []
sizeM (Matrix [xs]) = length xs : []
sizeM (Matrix (xs:xss)) = length xs : (sizeM (Matrix xss))

-- det :: Num a => Matrix a -> a
-- det (Matrix [])    = 0
-- det m@(Matrix xss) = if is_correct_size
--                      then calc_det
--                      else error "size mismatch" where
--                         is_correct_size = all_equal m_size && head m_size == length m_size
--                         m_size = sizeM xss
--                         calc_det = 42 


t0 = fromMatrix $ sumM  (Matrix [[1,2,3], [4,5,6]]) (Matrix [[7,8], [9,10], [11,12]])
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



-- Zadanie 7
instance Eq Natural where
    (==) = (==) `on` fromNatural

instance Ord Natural where
    (Natural xs) <= (Natural ys) = compare (reverse xs) (reverse ys)
      where
        compare :: [Word] -> [Word] -> Bool
        compare [] _ = True
        compare _ [] = False
        compare (x:xs) (y:ys) = x <= y && compare xs ys


-- Zadanie 10

-- val1 = (.)(.)
-- 1(.) :: (b -> c) -> ((a -> b) -> a -> c) // strzałki wiążą w prawo
-- 2(.) jest wrzucane do 1(.) jako (b -> c), czyli:
-- (b -> c) = (b1 -> c1) -> (a1 -> b1) -> a1 -> c1
-- stąd i z tego że strzałki wiążą w prawo
-- b = (b1 -> c1)
-- c = (a1 -> b1) -> a1 -> c1
-- teraz wynik jest typu ((a -> b) -> a -> c) - podstawiamy b i c
-- (a -> (b1 -> c1)) -> a -> (a1 -> b1) -> a1 -> c1
-- val1 :: (a -> b1 -> c1) -> a -> (a1 -> b1) -> a1 -> c1

-- val2 = (.)($)
-- ($) :: (a1 -> b1) -> (a1 -> b1)
-- podobnie jak wyżej
-- b = (a1 -> b1) 
-- c = (a1 -> b1)
-- podstawiamy b i c do typu (.)
-- (a -> (a1 -> b1)) -> a -> (a1 -> b1)
-- val2 :: (a -> a1 -> b1) -> a -> a1 -> b1

-- val3 = ($)(.)
-- ($) to identyczność na funkcjach
-- val3 :: (b -> c) -> (a -> b) -> a -> c

-- val4 = flip flip
-- flip :: (a -> b -> c) -> b -> a -> c
-- po prostu zamieniamy kolejność argumentów
-- val4 :: b -> (a -> b -> c) -> a -> c

-- val5 = (.)(.)(.)
-- (.)(.) :: (a -> b1 -> c1) -> a -> (a1 -> b1) -> a1 -> c1     //z poprzednich podpunktów
-- (.) :: (b2 -> c2) -> (a2 -> b2) -> a2 -> c2
-- a = (b2 -> c2)
-- b1 = (a2 -> b2)
-- c1 = (a2 -> c2)
-- val5 :: (b2 -> c2) -> (a1 -> a2 -> b2) -> a1 -> a2 -> c2

-- val6 = (.)($)(.)
-- (.) :: (b -> c) -> ((a -> b) -> (a -> c))
-- ($) :: (a1 -> b1) -> (a1 -> b1)
-- stąd:
-- (.)($) :: (a -> a1 -> b1) -> (a -> a1 -> b1)
-- (.) = (b2 -> c2) -> (a2 -> b2) -> a2 -> c2
-- a  = (b2 -> c2)
-- a1 = (a2 -> b2)
-- b1 = (a2 -> c2)
-- (b2 -> c2) -> (a2 -> b2) -> (a2 -> c2)
-- val6 :: (b2 -> c2) -> (a2 -> b2) -> a2 -> c2

-- val7 = ($)(.)(.)
-- ($)(.) :: (b -> c) -> (a -> b) -> a -> c     //identyczność
-- sprowadza się do (.)(.) z podpunktu wyżej
-- val7 ::  (a -> b1 -> c1) -> a -> (a1 -> b1) -> a1 -> c1

-- val8 = flip flip flip
-- flip :: (a -> b -> c) -> b -> a -> c
-- zamieniamy miejscami
-- flip flip :: b1 -> (a1 -> b1 -> c1) -> a1 -> c1
-- b1 = (a -> b -> c) -> b -> a -> c
-- val8 :: (a1 -> ((a -> b -> c) -> b -> a -> c) -> c1) -> a1 -> c1

-- val9 = tail $ map tail [[], ['a']]
-- map :: (a -> b) -> [a] -> [b]
-- tail :: [a] -> [a]
-- [[], ['a']] :: [[Char]]
-- map tail [[], ['a']] :: [[Char]]
-- tail $ map tail [[], ['a']] :: [[Char]]
-- val9 :: [[Char]]

-- val10 = let x = x in x x
-- val10 :: a ???

-- val11 = (\_ -> 'a') (head [])
-- head :: [a] -> a
-- head [] :: a
-- \_ -> 'a' :: a1 -> Char
-- val11 :: Char

-- val12 = (\(_,_) -> 'a') (head [])
-- head [] :: a
-- \(_,_) -> 'a' :: (a1, b) -> Char
-- a = (a1, b)
-- val12 :: Char

-- val13 = map map
-- map :: (a -> b) -> [a] -> [b]
-- a = (a1 -> b1)
-- b = [a1] -> [b1]
-- val13 :: [a1 -> b1] -> [[a1] -> [b1]]

-- val14 = map flip
-- flip :: (a -> b -> c) -> b -> a -> c
-- map :: (a1 -> b1) -> [a1] -> [b1]
-- a1 = a -> b -> c
-- b1 = b -> a -> c
-- val14 :: [a -> b -> c] -> [b -> a -> c]

-- val15 = flip map
-- zamieniony miejscami map
-- val15 :: [a] -> (a -> b) -> [b]