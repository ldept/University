#lang racket

(require racklog)

;; transpozycja tablicy zakodowanej jako lista list
(define (transpose xss)
  (cond [(null? xss) xss]
        ((null? (car xss)) (transpose (cdr xss)))
        [else (cons (map car xss)
                    (transpose (map cdr xss)))]))

;; procedura pomocnicza
;; tworzy listę n-elementową zawierającą wyniki n-krotnego
;; wywołania procedury f
(define (repeat-fn n f)
  (if (eq? 0 n) null
      (cons (f) (repeat-fn (- n 1) f))))

;; tworzy tablicę n na m elementów, zawierającą świeże
;; zmienne logiczne
(define (make-rect n m)
  (repeat-fn m (lambda () (repeat-fn n _))))

;; predykat binarny
;; (%row-ok xs ys) oznacza, że xs opisuje wiersz (lub kolumnę) ys
(define (app x)
  (if (= x 0)
      null
      (cons '* (app (- x 1)))))
(define %row-ok
  (%rel (x fs y xs ys)
;        [(null null)]
;        [((cons 0 xs) null)
;         (%row-ok xs null)]
;        [((cons 0 xs) (cons '- ys))
;         (%row-ok xs  ys)]
;        [((cons x xs) (cons '* ys))
;         (%> x 0)
;         
;         (%row-ok (cons x1 xs) ys)
;         (%is x (- x1 1))]
;        [((cons x xs) (cons '- ys))
;         (%row-ok (cons x xs) ys)]))

        [(null null)]
        [(xs (cons '- ys))
         (%row-ok xs ys)]
        [((cons x xs) ys)
         (%append (append (app x) (list '-)) fs ys)
         (%row-ok xs fs)]
        [((cons x xs) ys)
         (%is y (app x))
         (%= ys y)]))
        

;; TODO: uzupełnij!
  

;; TODO: napisz potrzebne ci pomocnicze predykaty
(define %rows-ok
  (%rel (r rows xss xs)
        [(null null)]
        [((cons r rows) (cons xs xss)
         (%row-ok r xs)
         (%rows-ok rows xss))]))

;; funkcja rozwiązująca zagadkę
(define (solve rows cols)
  (define board (make-rect (length cols) (length rows)))
  (define tboard (transpose board))
  (define ret (%which (xss tss) 
                      (%= xss board)
                      (%= tss board)
                      (%rows-ok rows xss)
                      (%rows-ok cols tss)
;; TODO: uzupełnij!
                      
                      ))
  (and ret (cdar ret)))

;; testy
(equal? (solve '((2) (1) (1)) '((1 1) (2)))
        '((* *)
          (_ *)
          (* _)))

;(equal? (solve '((2) (2 1) (1 1) (2)) '((2) (2 1) (1 1) (2)))
 ;       '((_ * * _)
  ;        (* * _ *)
   ;       (* _ _ *)
    ;      (_ * * _)))
;; TODO: możesz dodać własne testy

(define %simple-length
  (%rel (x xs n m)
        [(null 0)]
        [((cons x xs) n)
         (%simple-length xs m)
         (%is n (+ m 1))]))

