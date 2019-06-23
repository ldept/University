#lang racket

;; expressions

(define (const? t)
  (number? t))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * /))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op-cons op args)
  (cons op args))

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]))

(define (let-def? t)
  (and (list? t)
       (= (length t) 2)
       (symbol? (car t))))

(define (let-def-var e)
  (car e))

(define (let-def-expr e)
  (cadr e))

(define (let-def-cons x e)
  (list x e))

(define (let? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (car t) 'let)
       (let-def? (cadr t))))

(define (let-def e)
  (cadr e))

(define (let-expr e)
  (caddr e))

(define (let-cons def e)
  (list 'let def e))

(define (var? t)
  (symbol? t))

(define (var-var e)
  e)

(define (var-cons x)
  x)

(define (arith/let-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith/let-expr? (op-args t)))
      (and (let? t)
           (arith/let-expr? (let-expr t))
           (arith/let-expr? (let-def-expr (let-def t))))
      (var? t)))

;; let-lifted expressions

(define (arith-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith-expr? (op-args t)))
      (var? t)))

(define (let-lifted-expr? t)
  (or (and (let? t)
           (let-lifted-expr? (let-expr t))
           (arith-expr? (let-def-expr (let-def t))))
      (arith-expr? t)))

;; generating a symbol using a counter

(define (number->symbol i)
  (string->symbol (string-append "x" (number->string i))))

;; environments (could be useful for something)

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;; the let-lift procedure

(define (let-lift e)
  ;; TODO: Zaimplementuj!
  ;; Idea rozwiazania: stworzyc 2 listy i na koniec je ze soba zlozyc
  ;; 1: Lista definicji let-wyrazen w wyrazeniu "e"
  ;; 2: Lista ktora zawiera wyrazenie arytmetyczne

  (define (remove-duplicates l)
    (define (remove-duplicates-main l newl)
      (cond [(null? l) newl]
            [else
             (if (member (car l) newl)
                 (remove-duplicates-main (cdr l) newl)
                 (remove-duplicates-main (cdr l) (cons (car l) newl)))]))
    (define (reverse l newl)
      (cond [(null? l) newl]
            [else (reverse (cdr l) (cons (car l) newl))]))
    
    (reverse (remove-duplicates-main l null) null))

;;najpierw "wyciagnij" i przekaz jako liste wszystkie definicje let-wyrazen;
;;w tej liscie definicje sa ukladane od najglebszej, tj. jezeli w definicji
;;leta byl zagniezdzony kolejny, to ten drugi bedzie blizej poczatku listy,
;;natomiast jezeli to w let-expr wystapi kolejne let-wyrazenie to bedzie ono "za"
;;definicja i jej mozliwymi zagniezdzeniami
  (define (take-lets)
    (define (take-lets-main e let-list)
      (cond [(null? e) let-list]          
            [(op? e) (take-lets-main (op-args e) let-list)]
            ;;polacz listy 1) zagniezdzonych let-wyrazen w definicji
            ;;             2) let-wyrazen w let-expr
            ;;dodaj do "let-list" definicje let-wyrazenia "e" bez zagniezdzonych let-wyrazen
            ;;np. dla definicji (x (let (z 2) z) dodaj do "let-list" (x z)
            [(let? e) (append (take-lets-main (let-def-expr e)
                                      (add-to-env (let-def-var (let-def e))
                                                  (remove-let (let-def-expr(let-def e)))
                                                  let-list))
                              (take-lets-main (let-expr e) let-list))]
            [(list? e) (append (take-lets-main (car e) let-list)
                               (take-lets-main (cdr e) let-list))]
            [(var? e) null]
            [(const? e) null]
            ))
     (remove-duplicates (take-lets-main e empty-env))
    )

;;remove-let usuwa definicje letow pozostawiajac operacje arytm/liczby/zmienne
  (define (remove-let e)
    (cond [(null? e) e]
          [(const? e) e]
          [(var? e) e]
          [(op? e) (cons (op-op e) (remove-let (op-args e)))]
          [(let? e) (remove-let (let-expr e))]
          [(list? e) (cons (remove-let (car e)) (remove-let (cdr e)))]))
  
;;construct tworzy let-lifted-expr z dwoch list: let-list - lista uprzednio "wyciagnietych"
;;let-definicji, op - lista zawierajaca wyrazenie arytmetyczne
  (define (construct let-list op expr)
    (cond [(null? let-list) op]
          [else (let-cons (car let-list) (construct (cdr let-list) op expr))]))
  (construct (take-lets) (remove-let e) null)
  )

(module+ test
  (require rackunit)
  (display "Przyklady: \n")
  (display "1) ")'(let (x (- 2 (let (z 3) z))) (+ x 2))
  (display "2) ")'(+ 10 (* (let (x 7) (+ x 2)) 2))
  (display "3) ")'(+ (let (x 5) x) (let (x 1) x))
  (display "4) ")'(let (x (- 2)) (+ x (let (z 2) z)))
  (display "5) ")'(let (x (let (z 3) (- 5 z))) (let (y 4) (+ x y)))
  (display "\nLet-lifted: \n")
  (display "1) ")(let-lift '(let (x (- 2 (let (z 3) z))) (+ x 2)))
  (display "2) ")(let-lift '(+ 10 (* (let (x 7) (+ x 2)) 2)))
  (display "3) ")(let-lift '(+ (let (x 5) x) (let (x 1) x)))
  (display "4) ")(let-lift '(let (x (- 2)) (+ x (let (z 2) z))))
  (display "5) ")(let-lift '(let (x (let (z 3) (- 5 z))) (let (y 4) (+ x y))))
  (display "\nCzy 1-5 spelniaja let-lifted-expr?: ")
  (and (let-lifted-expr? (let-lift '(let (x (- 2 (let (z 3) z))) (+ x 2))))
       (let-lifted-expr? (let-lift '(+ 10 (* (let (x 7) (+ x 2)) 2))))
       (let-lifted-expr? (let-lift '(+ (let (x 5) x) (let (x 1) x))))
       (let-lifted-expr? (let-lift '(let (x (- 2)) (+ x (let (z 2) z)))))
       (let-lifted-expr? (let-lift '(let (x (let (z 3) (- 5 z))) (let (y 4) (+ x y)))))
       ))
  