module type PQUEUE =
sig
    type priority = int
    type 'a t

    exception EmptyQueue

    val empty : 'a t
    val insert : 'a t -> priority -> 'a -> 'a t

    val remove : 'a t -> priority * 'a * 'a t
end

module Pqueue : PQUEUE =
struct
    type priority = int
    type 'a t = (priority * 'a) list

    exception EmptyQueue

    let rec max_priority (q : 'a t) =
        match q with
        | []  -> raise EmptyQueue
        | [x] -> x
        | (p,e)::xs -> let p_next,e_next = max_priority xs
                        in if p > p_next then (p,e)
                                        else (p_next,e_next)
    let empty = []
    let insert (pqueue: 'a t) (p: priority) (el: 'a) = (p, el) :: pqueue


    let remove pqueue = 
        let max_p,max_e = max_priority pqueue in
        let rec remove_max = function
        | []        -> raise EmptyQueue
        | (p,e)::xs -> if max_p = p then xs 
                                    else (p,e)::(remove_max xs)
        in max_p,max_e,(remove_max pqueue)

end


let sort (l: int list) = 
    let rec make_pqueue = function
    | [] -> Pqueue.empty
    | x::xs -> Pqueue.insert (make_pqueue xs) x x
    in let rec make_final_list queue =
    try
        let _,elem,queue' = Pqueue.remove queue
        in elem :: (make_final_list queue')
    with
        Pqueue.EmptyQueue -> []
    in make_final_list (make_pqueue l)




