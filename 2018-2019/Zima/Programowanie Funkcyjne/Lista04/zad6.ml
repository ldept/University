type 'a place = {fstls: 'a list; sndls: 'a list}


let findNth ls n = 
    let rec find xs k acc = if k = 0 then { fstls=acc; sndls=xs}
                                else find (List.tl xs) (k-1) ((List.hd xs)::acc)
    in find ls n []


let collapse p =
    let rec concat_rev xs ys = 
    match xs with
    [] -> ys
|   h::t -> concat_rev t (h::ys)
in concat_rev (p.fstls) (p.sndls)

let add p n = { fstls=p.fstls; sndls=(n::(p.sndls))}

let del p = {fstls=p.fstls; sndls=(List.tl (p.sndls))}

let next p = {fstls=(List.tl (p.fstls)); sndls=((List.hd (p.fstls))::(p.sndls))}
let prev p = {fstls=((List.hd (p.sndls))::(p.fstls)); sndls=(List.tl (p.sndls))}

type 'a btplace = {fsttree: 'a btree; sndtree: 'a btree; nodenum : int}
