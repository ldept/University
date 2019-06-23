type 'var formula = False
    | True
    | Var of 'var
    | Not of 'var formula
    | And of 'var formula * 'var formula
    | Or of 'var formula * 'var formula

type 'var lit = 
    |Pos of 'var
    |Neg of 'var

type 'var nnf = 
    |NnfLit of 'var lit
    |NnfAnd of 'var nnf * 'var nnf
    |NNfOr of 'var nnf * 'var nnf

type 'var disjunct = 'var lit list
type 'var dnf = 'var disjunct list

let rec negnnf fm = 
        match fm with
        
        
let rec neg fm =
        match fm with
        False -> False
    |   True -> True
    |   Var(x) -> Var(x)
    |   Not(And(x,y)) -> Or(neg (Not(x)), neg (Not(y)))
    |   Not(Or(x,y)) -> And(neg (Not(x)), neg (Not(y)))
    |   Not(Not x) -> neg x
    |   Not(x) -> Not(neg x)
    |   And(x,y) -> And(neg x, neg y)
    |   Or(x,y) -> Or(neg x, neg y)

let rec dis fm = 
        match fm with
        False -> False
    |   True -> True
    |   Var(x) -> Var(x)
    |   Or(x1, And(x2,x3)) -> And(dis(Or(x1,x2)), dis(Or(x1,x3)))
    |   Or(And(x1,x2),x3) -> And(dis(Or(x1,x3)), dis(Or(x2,x3)))
    |   Or(x1, x2) ->
            let x1' = dis(x1) and x2' = dis(x2) in
                if x1 = x1' && x2 = x2' then OR(x1', x2')
                else dis(OR(x1', x2'))
    |   Var(x) -> Var(x)
    |   Not(x) -> Not(dis x)
    |   And(x,y) -> And(dis x, dis y)

let cnf fm = neg(dis fm)
(*
let rec dis fm = 
let rec con fm = 
    match fm with
    False -> False
|   True -> True
|   Var(x) -> Var(x)
|   And(x,y) -> And(con x, con y)
|   Or(x,y) -> And (Not (con x)
*)
