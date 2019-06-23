#lang racket

(define (inc x)
  (+ x 1))

(define precision 0.000001)

(define (square x) (* x x))

(define (cont-frac num den)

  ;;okresla k-te A lub B podane w zadaniu
  ;;na podstawie Ak-1 i Ak-2 (odpowiednio x y) lub Bk-1 i Bk-2
  (define (k-th n x y)
    (+ (* (den n) x)
       (* (num n) y)))
  
  (define (good-enough? x y)
    (< (abs (- x y)) precision))

  
  (define (cf-iter ak-2 ak-1 bk-2 bk-1 i)

    ;;ak, bk jak we wzorze podanym w zadaniu fk = Ak/Bk
    (let ([ak (k-th i ak-1 ak-2)]
          [bk (k-th i bk-1 bk-2)])
      (let ([f-prev (/ ak-1 bk-1)]
            [f-curr (/ ak   bk)])
        
        (if (good-enough? f-prev f-curr)
            f-curr
            (cf-iter ak-1 ak bk-1 bk (inc i))))))

  ;;zaczyna od i = 1, i odpowiednich wartosci dla Ak-2, Ak-1, Bk-2, Bk-1
  ;;podanych w zadaniu
  (cf-iter 1 0 0 1 1))

(module+ test
  (require rackunit)
  (define precision 0.0001)

  ;;okresla ciag liczb nieparzystych do testow
  (define (odd-s x)
    (- (* 2 x) 1))
  ;;okresla ciag licznikow z arctan do testow
  (define (l x i)
    (define n
      (if (= i 1)
          x
          (square (* (- i 1) x))))
    n)

  ;;cont-frac z zad.6 do testow
  (define (cf num dem k)
    (define (iter i acc)
      (if (= i 0)
          acc
          (iter (- i 1) (/ (num i) (+ (dem i) acc)))))
    (iter k 0.0))

  ;;cf-pi z zad.7 do testow
  (define (cf-pi k)
    (+ 3 (cf (lambda(i) (square (odd-s i)))
        (lambda(i) 6.0) k)))
          

  ;;testy ======================

  ;;pi
  [check-= (+ 3 (cont-frac (lambda(i) (square (odd-s i))) (lambda(i) 6.0)))
           (cf-pi (/ 1 precision))
           precision]

  ;;arctan
  [check-= (cont-frac (lambda(i) (l 10.0 i)) (lambda(i) (odd-s i)))
           (atan 10.0)
           precision]
  [check-= (cont-frac (lambda(i) (l -12.0 i)) (lambda(i) (odd-s i)))
           (atan -12.0)
           precision])
  
