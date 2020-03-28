-- Łukasz Deptuch
-- Kurs Języka Haskell
-- Lista 3, 27.03.2020
{-# LANGUAGE ViewPatterns, FlexibleInstances, IncoherentInstances, UndecidableInstances #-}

data BTree t a = Node (t a) a (t a) | Leaf

class BT t where
    toTree :: t a -> BTree t a

is_empty :: BT t => t a -> Bool
is_empty (toTree -> Leaf) = True
is_empty (toTree -> Node _ _ _) = False


-- Zadanie 1

treeSize :: BT t => t a -> Int
treeSize (toTree -> Leaf)       = 0
treeSize (toTree -> Node l _ r) = 1 + treeSize l + treeSize r

treeLabels :: BT t => t a -> [a]
treeLabels = flip aux [] where
    aux (toTree -> Leaf) acc       = acc
    aux (toTree -> Node l x r) acc = aux l (x : aux r acc)

treeFold :: BT t => (b -> a -> b -> b) -> b -> t a -> b
treeFold _ e (toTree -> Leaf) = e
treeFold n e (toTree -> Node l x r) = n (treeFold n e l) x (treeFold n e r)

data UTree a = UNode (UTree a) a (UTree a) | ULeaf

instance BT UTree where
    toTree ULeaf = Leaf
    toTree (UNode l x r) = Node l x r

newtype Unbalanced a = Unbalanced { fromUnbalanced :: BTree Unbalanced a }
instance BT Unbalanced where
    toTree = fromUnbalanced

-- Zadanie 2

searchBT :: (Ord a, BT t) => a -> t a -> Maybe a
searchBT _ (toTree -> Leaf) = Nothing
searchBT v (toTree -> Node left x right)
    | v == x = Just v
    | v <  x = searchBT v left
    | v >  x = searchBT v right

toUTree :: BT t => t a -> UTree a
toUTree (toTree -> Leaf) = ULeaf
toUTree (toTree -> Node l x r) = UNode (toUTree l) x (toUTree r)

toUnbalanced :: BT t => t a -> Unbalanced a
toUnbalanced (toTree -> Leaf) = Unbalanced Leaf
toUnbalanced (toTree -> Node l x r) = Unbalanced $ Node (toUnbalanced l) x (toUnbalanced r)


-- Zadanie 3

instance (BT t, Show a) => Show (t a) where
    show (toTree -> Leaf) = "-"
    show (toTree -> Node l@(toTree -> Leaf) x r@(toTree -> Leaf))          = show l ++ " " ++ show x ++ " " ++ show r 
    show (toTree -> Node l@(toTree -> Node l' x' r') x r@(toTree -> Leaf)) = "(" ++ show l ++ ")" ++ " " ++ show x ++ " " ++ show r
    show (toTree -> Node l@(toTree -> Leaf) x r@(toTree -> Node l' x' r')) = show l ++ " " ++ show x ++ " " ++  "(" ++ show r ++ ")" 
    show (toTree -> Node l x r) = "(" ++ show l ++ ")" ++ " " ++ show x ++ " " ++  "(" ++ show r ++ ")"


-- Zadanie 6
class BT t => BST t where
    node :: t a -> a -> t a -> t a
    leaf :: t a 

instance BST UTree where
    node = UNode
    leaf = ULeaf
instance BST Unbalanced where
    node l x r = Unbalanced $ Node l x r
    leaf = Unbalanced Leaf

class Set s where
    empty  :: s a
    search :: Ord a => a -> s a -> Maybe a
    insert :: Ord a => a -> s a -> s a
    delMax :: Ord a => s a -> Maybe (a, s a)
    delete :: Ord a => a -> s a -> s a


instance BST s => Set s where
    empty = leaf
    search = searchBT
    insert x (toTree -> Leaf) = node leaf x leaf
    insert x (toTree -> Node left v right)
        | x == v = node left v right --bez powtórzeń
        | x <  v = node (insert x left) v right
        | x >  v = node left v (insert x right)
    delMax (toTree -> Leaf) = Nothing
    delMax (toTree -> Node (toTree -> Leaf) x (toTree -> Leaf)) = Just (x, leaf)
    delMax (toTree -> Node t1 x (toTree -> Leaf)) = Just (x, t1)
    delMax (toTree -> Node t1 x t2) = Just (max, node t1 x t2deleted) where
        Just (max, t2deleted) = delMax t2 
    delete _ (toTree -> Leaf) = leaf
    delete x (toTree -> Node (toTree -> Leaf) v right)
        | x == v = right
        |otherwise = node leaf v (delete x right)
    delete x (toTree -> Node left v (toTree -> Leaf))
        | x == v = left
        | otherwise = node (delete x left) v leaf
    delete x tree@(toTree -> Node left v right)
        | x == v = node new_left new_v right -- naprawiamy drzewo usuwając max z lewego poddrzewa i wstawiając go w miejsce v
        | x >  v = node left v (delete x right)
        | x <  v = node (delete x left) v  leaf where
            Just (new_v, new_left) = delMax left