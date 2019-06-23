#lang racket

(define (neg x)
  (list 'neg x))

(define (disj x y)
  (list 'disj x y))

(define (conj x y)
  (list 'conj x y))

(define (disj-left t)
  (second t))

(define (disj-rght t)
  (third t))

(define (conj-left t)
  (second t))

(define (conj-rght t)
  (third t))

(define (neg-subf t)
  (second t))

(define (var? t)
  (symbol? t))
(define (neg? t)
  (and (list? t)
       (= 2 (length t))
       (eq? 'neg (car t))))
(define (conj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'conj (car t))))
(define (disj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'disj (car t))))

(define (prop? f)
  (or (var? f)
      (and (neg? f)
           (prop? (neg-subf f)))
      (and (disj? f)
           (prop? (disj-left f))
           (prop? (disj-rght f)))
      (and (conj? f)
           (prop? (conj-left f))
           (prop? (conj-rght f)))))

(define (literal? l)
  (or (var? l)
      (and (neg? l)
           (var? (neg-subf l)))))

;(define (free-vars? f))

(define (convert-to-nnf f)
  (define (convert-neg f)
    (cond [(var? f) (neg f)]
          [(neg? f) (convert-to-nnf f)]
          [(conj? f) (disj (convert-neg (conj-left f))
                           (convert-neg (conj-rght f)))]
          [(disj? f) (conj (convert-neg (disj-left f))
                           (convert-neg (disj-rght f)))]))
  (cond [(var? f) f]
        [(conj? f) (conj (convert-to-nnf (conj-left f)) (convert-to-nnf (conj-rght f)))]
        [(disj? f) (disj (convert-to-nnf (disj-left f)) (convert-to-nnf (disj-rght f)))]
        [(neg? f) (convert-neg (neg-subf f))]))

(define (gen-vals  xs)
  (if (null? xs)
      (list  null)
      (let*
          ((vss   (gen-vals (cdr xs)))
           (x     (car xs))
           (vst   (map (lambda (vs) (cons (list x true)   vs)) vss))
           (vsf   (map (lambda (vs) (cons (list x false) vs)) vss)))
        (append  vst  vsf))))

(define (eval-formula f xs)
  (define (find-val x l)
    (cond [(null? l) (error "404 var not found")]
          [(eq? x (caar l)) (cadr (car l))]
          [else (find-val x (cdr l))]))
  (cond [(var? f) (find-val f xs)]
        [(neg? f) (not (eval-formula (neg-subf f) xs))]
        [(conj? f) (and (eval-formula (conj-left f) xs) (eval-formula (conj-rght f) xs))]
        [(disj? f) (or (eval-formula (disj-left f) xs) (eval-formula (disj-rght f) xs))]))

(define form (neg (conj (conj 'p 'q) 'r)))
(define fi (gen-vals '(p q r)))
(define l (car fi))
(eval-formula form l)


(define (nnf? f)
  (or (literal? f)
      (and (disj? f)
           (nnf? (disj-left f))
           (nnf? (disj-rght f)))
      (and (conj? f)
           (nnf? (conj-left f))
           (nnf? (conj-rght f)))))