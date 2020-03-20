-- Łukasz Deptuch
-- Kurs języka Haskell
-- Lista 2, 20.03.2020
{-# LANGUAGE ParallelListComp #-}

-- Zadanie 1
spermC :: [a] -> [[a]]
spermC [] = [[]]
spermC xs = [ y:zs | (y,ys) <- select xs, zs <- spermC ys ] 
    where
        select [y] = [(y,[])]
        select (y:ys) = (y, ys) : [ (z, y:zs) | (z,zs) <- select ys ]

ipermC :: [a] -> [[a]]
ipermC [] = [[]]
ipermC (x:xs) = concat [ insert ys | ys <- ipermC xs ] 
    where
        insert [] = [[x]]
        insert ys'@(y:ys) = (x:ys') : [ y:y' | y' <- insert ys]

qsortC :: Ord a => [a] -> [a]
qsortC [] = []
qsortC (x:xs) = qsortC [ y | y <- xs, y <= x] ++ [x] ++ qsortC [ y | y <- xs, y > x]

subseqC :: [a] -> [[a]]
subseqC [] = [[]]
subseqC (x:xs) = [x:subseq | subseq <- subseqC xs] ++ subseqC xs

zipC :: [a] -> [b] -> [(a,b)]
zipC xs ys = [(x,y) | x <- xs | y <- ys]


-- Zadanie 3
data Combinator = S | K | Combinator :$ Combinator
infixl :$

instance Show Combinator where
    show S = "S"
    show K = "K"
    show (left_c :$ right_c@(_ :$ _)) = show left_c ++ "(" ++ show right_c ++ ")"
    show (left_c :$ right_c)          = show left_c ++ show right_c

 
-- Zadanie 5
data BST a = NodeBST (BST a) a (BST a) | EmptyBST deriving (Show)

searchBST :: Ord a => a -> BST a -> Maybe a
searchBST _ EmptyBST = Nothing
searchBST v (NodeBST left x right)
    | v == x = Just v
    | v <  x = searchBST v left
    | v >  x = searchBST v right


insertBST :: Ord a => a -> BST a -> BST a
insertBST v EmptyBST = NodeBST EmptyBST v EmptyBST
insertBST x (NodeBST left v right)
    | x == v = NodeBST left v right --bez powtórzeń
    | x <  v = NodeBST (insertBST x left) v right
    | x >  v = NodeBST left v (insertBST x right)

-- Zadanie 6

deleteMaxBST :: Ord a => BST a -> (BST a, a)
deleteMaxBST EmptyBST = error "deleteMax operation on empty tree"
deleteMaxBST (NodeBST EmptyBST x EmptyBST) = (EmptyBST, x)
deleteMaxBST (NodeBST t1 x EmptyBST) = (t1, x)
deleteMaxBST (NodeBST t1 x t2) = (NodeBST t1 x t2deleted, max) where
    (t2deleted, max) = deleteMaxBST t2 

-- deleteMaxBST tree = ((deleteBST x tree), x) where
--     x = findMaxBST tree

-- findMaxBST :: Ord a => BST a -> a
-- findMaxBST EmptyBST = error "deleteMax operation on empty tree"
-- findMaxBST (NodeBST _ x EmptyBST) = x
-- findMaxBST (NodeBST _ _ right) = findMaxBST right

deleteBST :: Ord a => a -> BST a -> BST a
deleteBST _ EmptyBST = EmptyBST
deleteBST x (NodeBST EmptyBST v right)
    | x == v = right
    |otherwise = NodeBST EmptyBST v (deleteBST x right)
deleteBST x (NodeBST left v EmptyBST)
    | x == v = left
    | otherwise = NodeBST (deleteBST x left) v EmptyBST
deleteBST x tree@(NodeBST left v right)
    | x == v = NodeBST new_left new_v right -- naprawiamy drzewo usuwając max z lewego poddrzewa i wstawiając go w miejsce v
    | x >  v = NodeBST left v (deleteBST x right)
    | x <  v = NodeBST (deleteBST x left) v  EmptyBST where
        (new_left,new_v) = deleteMaxBST left


-- test BST trees
t_BST = NodeBST (NodeBST EmptyBST 6 (NodeBST EmptyBST 7 EmptyBST)) 9 (NodeBST EmptyBST 10 EmptyBST)


-- Zadanie 7
data Tree23 a =   Node2 (Tree23 a) a (Tree23 a)
                | Node3 (Tree23 a) a (Tree23 a) a (Tree23 a)
                | Empty23 deriving(Show)


search23 :: Ord a => a -> Tree23 a -> Maybe a
search23 _ Empty23 = Nothing
search23 x (Node2 left v right)
    | x == v = Just x
    | x <  v = search23 x left
    | x >  v = search23 x right
search23 x (Node3 left v middle u right)
    | x == v || x == u = Just x
    | x < v = search23 x left
    | x < u = search23 x middle
    | x > u = search23 x right


-- test 2-3 trees
t23_2 = Node3 Empty23 4 Empty23 6 Empty23
t23_3 = Node3 (Node2 Empty23 8 Empty23) 9 (Node2 Empty23 10 Empty23) 11 Empty23

t23_4 = Node2 (Node3 Empty23 4 Empty23 6 Empty23) 7 (Node3 (Node2 Empty23 8 Empty23) 9 (Node2 Empty23 10 Empty23) 11 Empty23)