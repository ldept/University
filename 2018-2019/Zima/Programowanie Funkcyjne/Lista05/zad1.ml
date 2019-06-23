type 'a llist = LNil | LCons of 'a * (unit -> 'a llist)

let lhd = function
    LNil -> failwith "lhd"
|   LCons (x,_) -> x

let ltl = function
    LNil -> failwith "ltl"
|   LCons (_,xs) -> xs()

let rec ltake = function
    (0,_) -> []
|   (_,LNil) -> []
|   (n,LCons(x,xs)) -> x::ltake(n-1,xs())

let pi_l = 
    let rec pi_from1 k s = LCons(s *. 1.0 /.(k),function () -> pi_from1 (k +. 2.) (-.s))
    in pi_from1 1. 1.

let pi prec = 
    4. *. (List.fold_right (+.) (ltake (prec,pi_l)) 0.)

(*alt*)
let pi_prec =
    let rec pi_from4 k s sign= LCons(4.*.s,
                                    function () -> pi_from4 ( k+.2.) (s +. (sign*.(1. /. k))) (-.sign))
    in pi_from4 3. 1. (-.1.)

(*punkt2.*)

let rec natsfrom k = LCons(k,function() -> natsfrom (k+1))

let rec targ f stream = 
    match stream with
        LNil -> LNil
    |   LCons(x,xs) -> match xs() with
                        LNil -> failwith "targ"
                    |   LCons (y,ys) -> match ys() with
                                        LNil -> failwith "targ"
                                    |   LCons (z,_) -> LCons(f x y z, function() -> targ f (xs()))
let rec targ_let f stream = 
let x1 = lhd stream in
let x2 = lhd (ltl stream) in
let x3 = lhd (ltl (ltl stream)) in
LCons(f x1 x2 x3, function()-> targ_let f (ltl stream))
let euler x y z = z -. ( (y-.z) *. (y-.z) ) /. (x -. (2.*.y) +. z)

let pi_fast = targ euler pi_prec
let pi_fast_let = targ_let euler pi_prec



(* lazy version 


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


let rec targ f stream = 
    match stream with
        LNil -> LNil
    |   LCons(x,lazy xs) -> match xs with
                            LNil -> failwith "targ"
                        |   LCons (y,lazy ys) -> match ys with
                                                 LNil -> failwith "targ"
                                             |   LCons (z,_) -> LCons(f x y z, lazy (targ f xs))

*)
