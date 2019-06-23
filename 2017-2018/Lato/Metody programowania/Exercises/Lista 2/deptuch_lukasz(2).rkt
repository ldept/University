#lang racket

(define precision 0.00001)

(define (compose f g)
  (lambda(x) (f (g x))))

(define (repeated f n)
  (if (= n 1)
      f
      (compose f (repeated f (- n 1)))))

(define (fix-point f x0)
  (define (close-enough? x y)
    (< (abs(- x y)) precision))
  (let ((x1 (f x0)))
    (if (close-enough? x0 x1)
        x0
        (fix-point f x1))))

(define (average-damp f)
  (lambda (x) (/ (+ x (f x)) 2)))


(define (nth-root x n)

  ;;funkcja 
  (define (f y)
    (/ x (expt y (- n 1))))

  ;;oblicza najwieksza l. calkowita mniejsza od log o podstawie 2 z x
  (define (log2-floor x)
    (define (iter floor mult)
        (if (> mult x)
           (- floor 1)
           (iter (+ floor 1) (* mult 2))))
    (if (= x 1)
        1
        (iter 0 1)))
  
  ;;ilosc tlumien = najwiekszej liczbie calkowitej mniejszej od log o podst 2 z n
  (let ([damp-num (log2-floor n)])
    (fix-point ((repeated average-damp damp-num) f) 1.0)))


;;nth-root do eksperymentow
(define (nth-root-ex x n damp-num)
  (define (f y)
   (/ x (expt y (- n 1))))
    (fix-point ((repeated average-damp damp-num) f) 1.0))

;;testy eksperymentalne przeprowadzalem na (nth-root-ex 1024 x y)
;;gdzie x to stopien pierwiastka a y to ilosc tlumien
;;zaczynalem od x=1 i y=1 i zwiekszalem x o 1 do momentu, gdy funkcja sie zapetlala
;;wtedy zwiekszalem y o 1 i sprawdzalem czy przy tym samym x funkcja juz sie nie zapetla

;;wniosek z tych testow byl taki, ze gdy x byl kolejna potega dwojki trzeba bylo zwiekszyc ilosc tlumien
;;czyli trzeba bylo znalezc taka liczbe calkowita y, ze 2^y byla mniejsza lub rowna od x

;; (nth-root-ex 1024 1 1)
;; (nth-root-ex 1024 2 1)
;; (nth-root-ex 1024 3 1)
;; (nth-root-ex 1024 4 1) - zapetla sie
;; (nth-root-ex 1024 4 2) - ok
;; (nth-root-ex 1024 5 2)
;; (nth-root-ex 1024 6 2)
;; (nth-root-ex 1024 7 2)
;; (nth-root-ex 1024 8 2) - zapetla sie
;; (nth-root-ex 1024 8 3) - ok
;; (nth-root-ex 1024 9 3)
;; itd...

;; Przepraszam za brak testow nth-root, nie zdazylem.