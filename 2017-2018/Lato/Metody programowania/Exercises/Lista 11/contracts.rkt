#lang racket

(require racket/contract)

(define/contract foo number? 42)

(define/contract (dist x y)
  (-> number? number? number?)
  (abs (- x y)))

(define/contract (average x y)
  (-> number? number? number?)
  (/ (+ x y) 2))

(define/contract (square x)
  (-> number? number?)
  (* x x))

(define/contract (sqrt x)
  (->i ([x positive?])
       [result (x) (and/c positive?
                          (lambda(r) (< (dist x (square r)) 0.0001)))])
  ;; lokalne definicje
  ;; poprawienie przybliżenia pierwiastka z x
  (define (improve approx)
    (average (/ x approx) approx))
  ;; nazwy predykatów zwyczajowo kończymy znakiem zapytania
  (define (good-enough? approx)
    (< (dist x (square approx)) 0.0001))
  ;; główna procedura znajdująca rozwiązanie
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))


(define/contract (suffixes xs)
  (let ([a (new-∀/c 'a)])
    (-> (listof a) (listof (listof a))))
  (if (null? xs)
      (cons null null)
      (cons xs (suffixes (cdr xs)))))

(define/contract (filter p? xs)
  (let ([a (new-∀/c 'a)])
    (and/c
     (-> (-> a boolean?) (listof a) (listof a))
     (->i ([p? (-> any/c boolean?)]
           [xs (listof any/c)])
          [result (p?) (listof p?)])))
    
  (cond [(null? xs) null]
        [(p? (car xs)) (cons (car xs) (filter p? (cdr xs)))]
        [else (filter p? (cdr xs))]))

(define-signature  monoid^
  ((contracted
    [elem?    (-> any/c  boolean?)]
    [neutral  elem?]
    [oper     (-> elem? elem? elem?)])))
(define-unit monoid-int@
  (import)
  (export monoid^)

  (define (elem? x)
    (integer? x))
  (define neutral 0)
  (define (oper x y)
    (+ x y)))

(define-unit monoid-list@
  (import)
  (export monoid^)

  (define elem? list?)
  (define neutral null)
  (define (oper xs ys)
    (append xs ys)))

(define-values/invoke-unit/infer monoid-list@)

(require quickcheck)    
(quickcheck
 (property ([l (arbitrary-list arbitrary-integer)])
           (and (equal? (oper l neutral) l)
                (equal? (oper neutral l) l))))
(quickcheck
 (property ([l1 (arbitrary-list arbitrary-integer)]
            [l2 (arbitrary-list arbitrary-integer)]
            [l3 (arbitrary-list arbitrary-integer)])
           (equal? (oper l1 (oper l2 l3))
                   (oper (oper l1 l2) l3))))