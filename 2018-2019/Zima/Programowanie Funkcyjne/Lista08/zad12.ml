module type PQUEUE =
sig
    type priority
    type 'a t

    exception EmptyQueue

    val empty : 'a t
    val insert : 'a t -> priority -> 'a -> 'a t
    val remove : 'a t -> priority * 'a * 'a t

end

module type ORDTYPE =
sig
    type t
    type comparison = LT | EQ | GT
    val compare : t -> t -> comparison
end

module PQueue (OrdType : ORDTYPE) : PQUEUE with type priority = OrdType.t =
struct
    type priority = OrdType.t
    type 'a t = (priority * 'a) list
    exception EmptyQueue

    let empty = []
    let insert (pqueue: 'a t) (p: priority) (el: 'a) = (p, el) :: pqueue
    let rec max_priority (q : 'a t) =
        match q with
        | []  -> raise EmptyQueue
        | [x] -> x
        | (p,e)::xs -> let p_next,e_next = max_priority xs in
                       if OrdType.compare p p_next = OrdType.GT then (p,e) else (p_next,e_next)

    let remove pqueue = 
        let max_p,max_e = max_priority pqueue in
        let rec remove_max = function
        | []        -> raise EmptyQueue
        | (p,e)::xs -> if OrdType.compare max_p p = OrdType.EQ then xs 
                                                               else (p,e)::(remove_max xs)
        in max_p,max_e,(remove_max pqueue)

end

module IntOrder : ORDTYPE with type t = int = 
struct
    type t = int
    type comparison = LT | EQ | GT
    let compare x y = if x < y then LT else if x = y then EQ else GT
end

module IntPqueue = PQueue(IntOrder)

let sort (l : int list) = 
 let rec make_pqueue = function
    | [] -> IntPqueue.empty
    | x::xs -> IntPqueue.insert (make_pqueue xs) x x
    in let rec make_final_list queue =
    try
        let _,elem,queue' = IntPqueue.remove queue
        in elem :: (make_final_list queue')
    with
        IntPqueue.EmptyQueue -> []
    in make_final_list (make_pqueue l)

let sort_fc (type a) (module Ord : ORDTYPE with type t = a) lst = 
    let module PQ = PQueue (Ord) in
    let rec make_pqueue = function
    | [] -> PQ.empty
    | x::xs -> PQ.insert (make_pqueue xs) x x
    in let rec make_final_list queue =
    try
        let _,elem,queue' = PQ.remove queue
        in elem :: (make_final_list queue')
    with
        PQ.EmptyQueue -> []
    in make_final_list (make_pqueue lst)

