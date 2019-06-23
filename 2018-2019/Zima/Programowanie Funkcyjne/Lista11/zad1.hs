ana :: (b -> Maybe (a, b)) -> b -> [a]
ana f st = case f st of
  Nothing       -> []
  Just (v, st') -> v : ana f st'

my_zip::[a] -> [b] -> [(a,b)]
my_zip a b = ana zip_f (a,b)

zip_f :: ([a],[b]) -> Maybe ((a,b), ([a],[b]))
zip_f ([],_)      = Nothing
zip_f (_,[])      = Nothing
zip_f (x:xs,y:ys) = Just ((x,y),(xs,ys))

my_iterate::(a -> a) -> a -> [a]
my_iterate f x = ana iterate_f (f,x)

iterate_f :: ((a -> a), a) -> Maybe (a, ((a -> a), a))
iterate_f (f,x) = Just(x,(f,(f x)))

my_map :: (a -> b) -> [a] -> [b]
my_map f xs = ana map_f (f,xs)

map_f :: ((a -> b), [a]) -> Maybe (b, ((a -> b), [a]))
map_f (_,[])     = Nothing
map_f (f,(x:xs)) = Just ((f x),(f,xs))

-- ===================================================

cata :: (a -> b -> b) -> b -> [a] -> b
cata f v [] = v
cata f v (x:xs) = f x (cata f v xs)

my_filter::(a -> Bool) -> [a] -> [a]
my_filter p xs = cata (filter_f p) [] xs

filter_f::(a->Bool) -> (a -> [a] -> [a])
filter_f = (\p -> (\x -> (\xs -> if p x then (x:xs) else xs)))

my_cmap::(a -> b) -> [a] -> [b]
my_cmap f xs = cata (cmap_f f) [] xs

cmap_f::(a->b) -> (a -> [b] -> [b])
cmap_f = (\f -> (\y -> (\ys -> (f y):ys) ))
my_length::[a] -> Int
my_length xs = cata length_f 0 xs

length_f::a -> (Int -> Int)
length_f _ = (\x -> 1 + x)

-- ===================================================

data Expr a b =
   Number b
  | Var a
  | Plus (Expr a b) (Expr a b)

data Maybe3 a b c = Left a
  | Middle b
  | Right c

  ana :: (b -> Maybe (a, b)) -> b -> [a]
  ana f st = case f st of
    Nothing       -> []
    Just (v, st') -> v : ana f st'
anac f state = case f state of
  Left x      -> Number x
  Middle x    -> Var x
  Right (x,y) -> Plus (anac f x) (anac f y)

eval::Num b => [(a,b)] -> Expr a b -> b
eval env expr = anac eval_f (env,expr)
{-eval env expr = case expr of
   Number x -> x
   Var x -> find x env
   Plus e1 e2 -> (eval env e1) + (eval env e2)
-}

ana' f state = case f state of


find::a -> [(a,b)] -> b
find _ [] = error "no such variable"
find x ((x',y):xs) = if x == x' then y else find x xs
