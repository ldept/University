module type VERTEX =
sig
    type t
    type label
    val equal : t -> t -> bool
    val create : label -> t
    val label : t -> label
end

module type EDGE =
sig
    type t
    type label
    type vertex

    val equal : t -> t -> bool
    val create : label -> vertex -> vertex -> t
    val label : t -> label
    val start_p : t -> vertex
    val end_p : t -> vertex
end

module Vertex : VERTEX with type label = string =
struct
    type label = string
    type t = label
    let equal v1 v2 = v1 = v2
    let create l = l
    let label v = v
end

module Edge : EDGE with type vertex = Vertex.t and type label = string =
struct
    type label = string
    type vertex = Vertex.t
    type t = vertex * vertex * label

    let start_p e = let (v1,_,_) = e in v1
    let end_p e =   let (_,v2,_) = e in v2
    let label e =   let (_,_,l)  = e in l
    let create l v1 v2 = (v1,v2,l)
    let equal e1 e2 = Vertex.equal (start_p e1) (start_p e2) && Vertex.equal (end_p e1) (end_p e2) && label e1 = label e2
end
