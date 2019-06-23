#lang typed/racket

(: prefixes (All (A) (-> (Listof A) (Listof (Listof A)))))
(define (prefixes xs)
  (reverse (suffixes (reverse xs))))

(: suffixes (All (A) (-> (Listof A) (Listof (Listof A)))))
(define (suffixes xs)
  (if (null? xs)
      (cons null null)
      (cons (cdr xs) (suffixes (cdr xs)))))
  ;  (if (null? xs)
;      (cons null null)
;      (cons (list (car xs)) (prefixes (cdr xs)))))

(define-type (Rose-Tree A) (U Leaf (Node A (Rose-Tree A))))
(define-type Leaf 'leaf)
(define-type (Node A B) (List 'node A (Listof B)))

(define-predicate leaf? Leaf)
(define-predicate node? (Node Any Any))
(define-predicate rose-tree? (Rose-Tree Any))

(: node-val (All (A B) (-> (Node A B) A)))
(define (node-val x)
  (second x))

(: node-trees (All (A B) (-> (Node A B) (Listof B))))
(define (node-trees x)
  (third x))

(: leaf Leaf)
(define leaf 'leaf)

(: make-node (All (A B) (-> A (Listof B) (Node A B))))
(define (make-node val xs)
  (list 'node val xs))

(: flatten (All (A) (-> (Rose-Tree A) (Listof A))))
(define (flatten tree)
  (cond [(leaf? tree) null]
        [(node? tree) (cons (node-val tree) (flatten (node-trees tree)))]))
