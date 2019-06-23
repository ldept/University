#lang racket


(define (make-rat n d)
  (cons n (cons d null)))

(define (rat? x)
  (and (pair? x)
       (pair? (cdr x))
       (integer? (car x))
       (integer? (car (cdr x)))
       (null? (cdr (cdr x)))
       (not (= (car (cdr x)) 0))))

(define (rat-num x)
  (if (rat? x)
      (car x)
      (error "Not a rational number")))
(define (rat-den x)
  (if (rat? x)
      (car (cdr x))
      (error "Not a rational number")))

(define f (make-rat 3.1 5))

(rat-den f)






       
