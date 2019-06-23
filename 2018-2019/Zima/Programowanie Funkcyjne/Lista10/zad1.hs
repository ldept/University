data BTree a = Leaf | Node ( BTree a ) a ( BTree a )
                deriving Show


--find a [] = 0
--find a (x:xs) = if a = x
dfnum :: BTree a -> BTree Integer
{-dfnum t = fst (forestNum 1 [t]) where
            forestNum :: [BTree a] -> Integer -> [BTree Integer]
            forestNum [] n = []
            forestNum (Leaf:ts) n = Leaf:(forestNum n ts)
            forestNum (Node l _ r :ts) n = let (l':r':ts') = forestNum (l:r:ts) (n+1) in
                                            Node l' n r' : ts
-}

bfnum t = t' where 
            (t'

t1 = Node ( Node ( Node Leaf 'a' Leaf ) 'b' Leaf ) 'c' ( Node Leaf 'd' Leaf )


data Array a = Array (BTree a) Integer
                deriving Show

aempty:: Array a
aempty = Array Leaf 0

asub::Array a -> Integer -> a
asub (Array (Node left a right) size) k = if k == 1 then a
                                            else if k `mod` 2 == 0 then asub (Array left size) (k `div` 2)
                                                    else asub (Array right size) (k `div` 2)

arr1 = Array t1 4
aupdate :: Array a -> Integer -> a -> Array a
aupdate (Array tree size) k a = Array (change tree k a) size
                                where
                                    change:: BTree a -> Integer -> a -> BTree a
                                    change Leaf _ _ = error "no such element"
                                    change (Node l v r) i elem
                                        | i == 1 = (Node l elem r)
                                        | i `mod` 2 == 0 = Node (change l (i `div` 2) elem) v r
                                        | otherwise = Node l v (change r (i `div` 2) elem)


ahiext :: Array a -> a -> Array a
ahiext (Array tree size) a = Array (add tree a (size + 1)) (size + 1)
                            where
                                add:: BTree a -> a -> Integer -> BTree a
                                add Leaf a _ = Node Leaf a Leaf
                                add (Node l v r) a k
                                    | k == 1 = Node Leaf a Leaf
                                    | k `mod` 2 == 0 = Node (add l a (k `div` 2)) v r
                                    | otherwise = Node l v (add r a (k `div` 2))

ahirem :: Array a -> Array a
ahirem (Array tree size) = Array (remove tree size) (size - 1)
                            where
                                remove :: BTree a -> Integer -> BTree a
                                remove Leaf _ = error "Pusta"
                                remove (Node l v r) k
                                    | k `div` 2 == 1 = if k `mod` 2 == 0 then Node Leaf v r
                                                                         else Node l v Leaf
                                    | otherwise = if k `mod` 2 == 0 then Node (remove l (k `div` 2)) v r
                                                                    else Node l v (remove r (k `div` 2))
