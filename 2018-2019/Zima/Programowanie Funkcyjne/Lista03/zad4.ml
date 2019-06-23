(*1.*)

let isSquareMatrix xs = List.for_all (fun x -> List.compare_lengths x xs = 0) xs

(*2.*)

let nth_col xs n = List.map (fun x -> List.nth x (n-1)) xs

(*3.*) 

let transposition xs = 
    let rec trans n = 
        if n > List.length xs then [] else (nth_col xs n)::trans (n+1)
    in trans 1

(*4.*)

let zip xs ys = List.combine xs ys

(*5.*)

let zipf f xs ys = List.map (fun (x,y) -> f x y) 
                            (zip xs ys)

(*6.*)

let mult_vec v m = List.map (fun x -> (List.fold_right (+.) x 0.)) 
                            (List.map (fun x -> zipf ( *. ) v x) (transposition m))

(* Komentarz: 
    * (List.map (fun x -> zipf ( *. ) v x) (transposition m)) Tworzy listę list wyników iloczynów
    * po czym nałożone "List.map (fun x -> (List.fold_right (+.) x 0.)" sumuje listy wyników iloczynów i zostawia listę wyników mnożenia wektora przez macierz
*)

(*7.*)

let mult_matrices m1 m2 = List.map (fun x -> mult_vec x m2) m1






