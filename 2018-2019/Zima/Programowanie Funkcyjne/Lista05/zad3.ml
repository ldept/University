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


