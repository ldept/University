
let rec poly xs x = 
    match xs with
    [] -> raise (Invalid_argument "[]")
|   [y] ->  x *. 0. +. y
|   hd::tl -> hd +. x *. (poly tl x)

(* List.fold *)

let polyList ls xs = List.fold_right (fun x y -> y *. xs +. x) ls 0.
