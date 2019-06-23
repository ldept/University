#lang racket

(require racklog)

(define %simple-length
  (%rel (x xs n m)
        [(null 0)]
        [((cons x xs) n)
         (%simple-length xs m)
         (%is n (+ m 1))]))

(define %select
  (%rel (x xs y ys)
        [(x (cons x xs) xs)]
        [(y (cons x xs) (cons x ys))
         (%select y xs ys)]))

(define %=
  (%rel (x)
        [(x x)]))

(define %not=
  (%rel (x y)
        [(x x) ! %fail]
        [(x y)]))

(define %unifiable
  (%rel (x y)
        [(x y)
         (%not= x y) ! %fail]
        [(x y)]))

(define %sublist
  (%rel (x xs ys)
        [(null ys)]
        [((cons x xs) (cons x ys))
         (%sublist xs ys)]
        [((cons x xs) (cons _ ys))
         (%sublist (cons x xs) ys)]))

(define %perm
  (%rel (x y xs ys)
        [(null null)]
        [((cons x xs) (cons x ys))
         (%perm xs ys)]
        [((cons x xs) (cons y ys))
         (%perm xs (%select x (cons y ys)))]))