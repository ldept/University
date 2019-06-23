(* =============== Zad 3 =================== *)
type 'var formula =
    | Var of 'var
    | And of 'var formula * 'var formula
    | Or of 'var formula * 'var formula
    | Imp of 'var formula * 'var formula

type 'a proof = 
    Proof of 'a elements list * 'a formula
    and 'a elements = 
        Formula of 'a formula
    |   Frame of 'a formula * 'a proof

(* ========================================= *)

let rec remove_duplicates xs = 
    match xs with
    []   -> []
|   h::t -> if List.mem h t then remove_duplicates t else h::(remove_duplicates t)

let rec remove_duplicates_pairs xs =
    match xs with
    [],[] -> [],[]
|   x,[] -> (remove_duplicates x), []
|   [],x -> [], (remove_duplicates x)
|   x,y -> (remove_duplicates x), (remove_duplicates y)

let rec form_pos_neg f =
        match f with
    |   Var(x)   -> [x], []
    |   And(x,y) -> let pos_x,neg_x = form_pos_neg x in
                    let pos_y,neg_y = form_pos_neg y in
                    pos_x@pos_y, neg_x@neg_y
    |   Or (x,y) -> let pos_x,neg_x = form_pos_neg x in
                    let pos_y,neg_y = form_pos_neg y in
                    pos_x@pos_y, neg_x@neg_y
    |   Imp(x,y) -> let neg_x,pos_x = form_pos_neg x in
                    let pos_y,neg_y = form_pos_neg y in
                    pos_x@pos_y, neg_x@neg_y


let rec proof_pos_neg p = 
    let rec proof_pos_neg_aux p =
        match p with
    |   []    -> [], []
    |   e::el -> let pos', neg' = proof_pos_neg_aux el in
                 match e with
                | Formula(f) -> let pos_f, neg_f = form_pos_neg f in pos_f@pos', neg_f@neg'
                | Frame(f,p) -> let neg_f, pos_f = form_pos_neg f in 
                                let pos_p, neg_p = proof_pos_neg p in
                                pos_p@pos_f@pos', neg_p@neg_f@neg'
      in match p with
      |  Proof(el,_) -> remove_duplicates_pairs (proof_pos_neg_aux el)


let proof1 = Proof (
                [Frame(
                    And(Var('p'), Imp(Var('p'),Var('q'))),
                    Proof( [ Formula( Var ('p')) ; Formula( Imp(Var('p'), Var('q'))) ], (Var('q'))))],
                (Imp( And(Var('p'), Imp(Var('p'),Var('q'))), Var('q'))) )

let form1 = Imp (And (Var 'p', Imp (Var 'p', Var 'q')), Var 'q')

