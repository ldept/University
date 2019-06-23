(* Zad. 1 *)
(*
fun x -> x

fun x -> +x

fun f g x = f (g(x))

let rec f x = f x
*)

(* Zad. 2 *)

let id x = x

let rec rekursja n = if n = 0 then 0 else 1 + 2 * rekursja(n-1)

let rec help n acc = if n = 0 then acc else help(n-1) (2*acc + 1)
let rec ogon n = help n 0

(* Zad. 3 *)

let compose f g x = f( g(x) )


let rec iterhelp n acc f = if n = 0 then acc else iterhelp (n-1) (compose f acc) f

let iter n f = iterhelp n id f

let (+++) a n = (iter n ( (+) a)) 0

let potegowanie a n = (iter n ( (+++) a)) 1

(* Zad. 4 *)

let hd s = s(0)
let tl s = fun n -> s(n+1)
let add s a = fun n -> s(n) + a
let map s f = fun n -> f(s(n))
let map2 s1 s2 f = fun n -> (f s1(n) s2(n))
let replace s a n = fun i -> (if (i mod n = 0) then a else s(i))
let take s n = fun i -> s(i*n)

let rec concat x n s acc = if x = n then acc else (concat (x+1) n s (acc@[s(x)]))
let tabulate ?(x=0) n s = (concat x n s [])
