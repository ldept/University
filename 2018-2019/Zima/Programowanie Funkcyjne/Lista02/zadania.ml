(*Zad.1*)

(*Zad.2*)

(*let rec cycle xs n = if n = 0 then xs else cycle ((tail xs)@[(head xs)]) (n - 1)
*)
let head xs = 
    match xs with
        []     -> raise (Invalid_argument "[]") 
    |   hd::_ -> hd

let tail xs =
    match xs with
        [] -> []
    |   _::tl -> tl

let rec length xs = 
    match xs with
        [] -> 0
    |   _::tl -> 1 + (length tl)

let rec (@@) xs ys =
    match xs with
    hd::tl -> hd::(append tl ys)
|    [] -> ys

let rec reverse_acc xs acc = 
    match xs with
        hd::tl -> (reverse_acc tl (hd::acc))
    |   [] -> acc

let reverse xs = reverse_acc xs []

(*Zad.2*)

let rec cycle_acc xs acc n = if (length xs) = n then xs@(reverse acc) else cycle_acc (tail xs) (head::acc) n


let cycle xs n = cycle_acc xs [] n




(*Zad.3*)
(*
let rec merge_tail f xs ys acc = 
    if (length xs) = 0 then acc@ys 
        else if (length ys) = 0 then acc@xs 
            else if f (head xs) (head ys) then merge_tail f (tail xs) ys (acc@[head xs])
                else merge_tail f xs (tail ys) (acc@[head ys])

let rec merge f xs ys = 
    if xs = [] then ys
        else if ys = [] then xs
            else if f (head xs) (head ys) then [(head xs)]@(merge f (tail xs) ys)
                else [(head ys)]@(merge f xs (tail ys))
    *)              
let rec merge f xs ys =
    match xs, ys with
    [], _ -> ys
|   _, [] -> xs
|   hdx::tlx, hdy::tly -> if f hdx hdy then hdx::(merge f tlx ys)
                                        else hdy::(merge f xs tly) 


let rec merge_tail f xs ys acc =
    match xs, ys with
    [], _ -> (reverse acc)@ys
|   _,[] -> (reverse acc)@xs
|   hdx::tlx, hdy::tly -> if f hdx hdy then merge_tail f tlx ys (hdx::acc)
                                        else merge_tail f xs tly (hdy::acc)

let rec split_acc xs acc n = if n = 0 then ((reverse acc),xs) 
                                        else split_acc (tail xs) ((head xs)::acc) (n-1)

let split xs = split_acc xs [] ((length xs)/2)

(*
let rec merge_sort f xs = 
    if (length xs) = 1 then [(head xs)]
        else let lp = (split xs)
               in merge_tail f (merge_sort f (fst lp)) (merge_sort f (snd lp)) []
*)
let rec merge_sort f xs = 
    match xs with
    [x] -> [x]
|   [] -> []
|   _ -> let lp = split xs
            in merge_tail f (merge_sort f (fst lp)) (merge_sort f (snd lp)) []

(*Zad. 4*)


let rec partition_acc p xs acc1 acc2 = 
    match xs with
    [] -> (acc1,acc2)
|   hd::tl -> if p hd then partition_acc p tl (hd::acc1) acc2
                        else partition_acc p tl acc1 (hd::acc2)
(*
    if xs = [] then (acc1,acc2) else
     if p (head xs) then partition_acc p (tail xs) (acc1@[head xs]) acc2 else partition_acc p (tail xs) acc1 (acc2@[head xs])
  *)  
let partition p xs = partition_acc p xs [] []

(*podpunkt 2.*)

let rec quicksort f xs = 
    match xs with 
        [] -> []
    |   hd::_ ->  let p x = f hd x in 
                        let xsp = (partition p xs) in (quicksort f (fst xsp))@(quicksort f (snd xsp))

(*Zad. 6*)

(*let rec suffixes_acc xs = if xs = [] then []::[] else xs::suffixes_acc (tail xs)
*)

let rec suffixes xs = 
    match xs with
    [] -> []::[]
|   _::tl -> xs::suffixes tl
(*
let rec prefixes_acc xs acc = if xs = [] then acc::[] else acc::prefixes_acc (tail xs) (acc@[(head xs)]) *)
let rec prefixes xs = 
    match xs with
    [] -> []::[]
|   hd::tl -> []::(List.map (fun x -> (hd::x)) (prefixes tl))


