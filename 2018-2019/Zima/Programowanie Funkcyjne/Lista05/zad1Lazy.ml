type 'a llist = LNil | LCons of 'a * 'a llist Lazy.t

let lhd = function
    LNil -> failwith "lhd"
|   LCons (x,_) -> x

let ltl = function
    LNil -> failwith "ltl"
|   LCons (_,lazy xs) -> xs

let rec ltake = function
    (0,_) -> []
|   (_,LNil) -> []
|   (n,LCons(x,lazy xs)) -> x::ltake(n-1,xs)

let pi_l = 
    let rec pi_from1 k s = LCons(s *. 1.0 /.(k),lazy ( pi_from1 (k +. 2.) (-.s)))
    in pi_from1 1. 1.

