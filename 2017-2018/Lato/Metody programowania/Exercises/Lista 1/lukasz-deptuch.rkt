#lang racket

(define (dist x y)
  (abs (- x y)))

(define (square x)
  (* x x))

(define (cube x)
  (* x x x))

(define (average-3 x y z)
  (/ (+ x y z) 3))

(define (cube-root x)
  
  ;;precyzja uzywana do przyblizania wartosci
  (define precision 0.00001)
  
  ;;znajdz lepsze przyblizenie 
  ;;przy czym (abs x) pilnuje, zeby przy x = -2 funkcja sie nie zapetlala
  (define (improve approx)
    (average-3 [/ (abs x) (square approx)] approx approx))

  ;;funkcja good-enough? poprawiona w oparciu o cw. 1.7 z ksiazki
  ;;sprawdza czy kolejne przyblizenia niewiele sie od siebie roznia
  ;;(konkretnie, gdy wart. bezwgledna ich roznicy jest mniejsza od ustalonej precyzji)
  ;;to poprawia dzialanie funkcji cube-root dla duzych i malych liczb
  (define (good-enough? approx approx-prev)
    (< (dist approx-prev approx) precision))
  
  (define (iter approx approx-prev)
    (cond
      [(good-enough? approx approx-prev) approx]
      [else                              (iter (improve approx) approx)]))

  ;;iter wylicza wartosci bezwgledne (zeby nie pojawial się problem przy x = -2)
  ;;stad dodatkowy warunek, który przy koncowym wyniku uzwglednia znak liczby x
  (cond
    [(> x 0) (+ (iter 1.0 0.0))]
    [(< x 0) (- (iter 1.0 0.0))]
    [else 0]
    ))

;;testy
(module+ test
  (require rackunit)
  ;;precyzja uzywana do testow
  (define precision 0.00001)
  [check-= (cube (cube-root 27)) 27 (* precision 27)]
  [check-= (cube (cube-root -2)) -2 (* precision 2)]
  [check-= (cube (cube-root 0)) 0 (* precision 0)]
  [check-= (cube (cube-root 98765432123456789)) 98765432123456789 (* precision 98765432123456789)]
  [check-= (cube (cube-root -98765432123456789)) -98765432123456789 (* precision 98765432123456789)]
  ;;przy zwiekszonej precyzji mozna porownywać mniejsze liczby (przynajmniej tym sposobem)
  [check-= (cube (cube-root 0.0000000004)) 0.0000000004 (* precision 0.0000000004)]
  [check-= (cube (cube-root -0.0000000004)) -0.0000000004 (* precision 0.0000000004)])


