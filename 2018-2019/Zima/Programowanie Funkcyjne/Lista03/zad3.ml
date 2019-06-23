let duplicates xs = 
    let rec duplicates_help xs acc = 
        match xs with
        [] -> acc::[]
    |   hd::tl -> match acc with
                    [] -> duplicates_help tl [hd]
                  | h::_ -> if h = hd then duplicates_help tl (hd::acc) else acc::duplicates_help tl [hd]
    in duplicates_help xs []
