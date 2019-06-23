
let poly xs x =
    let rec poly_rec xs x acc = 
        match xs with
        [] -> raise (Invalid_argument "[]")
    |   [y] -> acc *. x +. y
    |   hd::tl -> poly_rec tl x (acc *. x +. hd)
    in poly_rec xs x 0.
(* List.fold *)

let polyList ls xs = List.fold_left (fun x y -> x *. xs +. y) 0. ls
