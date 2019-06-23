#lang racket

(define (display-point p)
  (display "(")
  (display (point-x p))
  (display ", ")
  (display (point-y p))
  (display ")"))

(define (display-vect v)
  (display "[")
  (display-point (vect-begin v))
  (display ", ")
  (display-point (vect-end v))
  (display "]"))

;;Punkty ==========================

(define (make-point x y)
  (cons x y))

(define (point? x)
  (and (pair? x)
       (integer? (car x))
       (integer? (cdr x))))

(define (point-x x)
  (car x))

(define (point-y y)
  (cdr y))

;;Wektory ========================

(define (make-vect x y)
  (cons x y))

(define (vect-begin x)
  (car x))

(define (vect-end x)
  (cdr x))

(define (vect? x)
  (and (pair? x)
       (point? vect-begin)
       (point? vect-end)))

;;Procedury =====================
(define (square x)
  (* x x))

(define (vect-length x)
  (let ([x1 (point-x (vect-begin x))]
        [x2 (point-x (vect-end x))]
        [y1 (point-y (vect-begin x))]
        [y2 (point-y (vect-end x))])
    (sqrt (+ (square (- x1 x2)) (square (- y1 y2))))))

(define (vect-scale v k)
  (let ([p (vect-begin v)]
        [r (vect-end v)]
        [x2 (point-x (vect-end v))]
        [y2 (point-y (vect-end v))])
    (define x (make-point (+ (* (/ (- k 1) k) (point-x (vect-begin v)))
                             (* (/ 1 k) x2))
                          (+ (* (/ (- k 1) k) (point-y (vect-begin v)))
                             (* (/ 1 k) y2))))
    (make-vect p x)))

(define (vect-translate v p)
  (let ([x-change (- (point-x (vect-begin v)) (point-x p))]
        [y-change (- (point-y (vect-begin v)) (point-y p))])
    (make-vect p (make-point (- (point-x (vect-end v))
                                x-change)
                             (- (point-y (vect-end v))
                                y-change)))))
        

(define p1 (make-point 1 3))
(define p2 (make-point 5 7))
(define v (make-vect p1 p2))
(define p (make-point 1 0))

    
    

