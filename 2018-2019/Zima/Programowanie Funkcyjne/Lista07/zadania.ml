(* Zad.1 *)

let rec fix f x = f (fix f) x


let fact_norec n =
    let acc = ref (fun x -> x) in
    let fact_aux = function
    | 0 -> 1
    | k -> k * (!acc (k-1))
    in acc := fact_aux;
    !acc n

let fix_norec f =
    let acc = ref (fun _ -> assert false) in
    let fix_aux f n = f (!acc f) n in
    acc := fix_aux;
    !acc f
(* Zad.4 *)
let fresh,reset = 
    let c = ref 0 in 
    let fresh = 
        fun(s:string) -> 
        c := !c + 1; s^string_of_int !c in 
    let reset i = c := i in
    fresh,reset;;



(*let josephus n m =
    let rec clist num = 
    match num with
    |   0 -> clist;;
    |   x -> x::clist;;
*)


(* Zad.2 *)
type 'a list_mutable = LMnil | LMcons of 'a * 'a list_mutable ref

let concat_share l1 l2 =
    match l1 with
    | LMnil -> l2
    | _     -> let rec set_last = function
                                | LMcons(_,l) -> if !l=LMnil then l:=l2 else set_last !l
                                | LMnil -> failwith "concat_share : this is impossible !!"
               in set_last l1 ; l1 

let test_lm1 = LMcons (5, ref (LMcons (4, ref LMnil)))
let test_lm2 = LMcons (1, ref (LMcons (2, ref LMnil)))

(* Zad 3 *)


type ('a, 'b) arr = Empty
                  | Array of 'a * 'b * (('a, 'b)arr)

let empty = Empty

let rec get n = function 
    |Empty         -> None
    |Array(a,b,xs) -> if a = n then Some b else get n xs

let rec add x y = function
    |Empty -> Array(x,y,Empty)
    |Array(a,b,xs) -> Array(a,b,(add x y xs))

let rec fib_memo = 
    let ar = ref empty in
    function n -> 
    match get n !ar with
    |None   -> if n < 2 then 1 else 
                                let res = fib_memo (n-1) + fib_memo (n-2) in
                                ar := add n res !ar;
                                res
    |Some x -> x

let rec fib n = if n < 2 then 1 else fib(n-1) + fib(n-2)





