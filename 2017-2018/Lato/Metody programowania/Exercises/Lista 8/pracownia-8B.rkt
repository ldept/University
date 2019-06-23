#lang racket

;; pomocnicza funkcja dla list tagowanych o określonej długości

(define (tagged-tuple? tag len p)
  (and (list? p)
       (= (length p) len)
       (eq? (car p) tag)))

(define (tagged-list? tag p)
  (and (pair? p)
       (eq? (car p) tag)
       (list? (cdr p))))

;; self-evaluating expressions

(define (const? t)
  (or (number? t)
      (my-symbol? t)
      (eq? t 'true)
      (eq? t 'false)))

;; arithmetic expressions

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * / = > >= < <= eq?))))

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
        [(eq? op '/) /]
        [(eq? op '=)  (compose bool->val =)]
        [(eq? op '>)  (compose bool->val >)]
        [(eq? op '>=) (compose bool->val >=)]
        [(eq? op '<)  (compose bool->val <)]
        [(eq? op '<=) (compose bool->val <=)]
        [(eq? op 'eq?) (lambda (x y)
                         (bool->val (eq? (symbol-symbol x)
                                         (symbol-symbol y))))]))

;; symbols

(define (my-symbol? e)
  (and (tagged-tuple? 'quote 2 e)
       (symbol? (second e))))

(define (symbol-symbol e)
  (second e))

(define (symbol-cons s)
  (list 'quote s))

;; lets

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
  (and (tagged-tuple? 'let 3 t)
       (let-def? (cadr t))))

(define (let-def e)
  (cadr e))

(define (let-expr e)
  (caddr e))

(define (let-cons def e)
  (list 'let def e))
        
;; variables

(define (var? t)
  (symbol? t))

(define (var-var e)
  e)

(define (var-cons x)
  x)

;; pairs

(define (cons? t)
  (tagged-tuple? 'cons 3 t))

(define (cons-fst e)
  (second e))

(define (cons-snd e)
  (third e))

(define (cons-cons e1 e2)
  (list 'cons e1 e2))

(define (car? t)
  (tagged-tuple? 'car 2 t))

(define (car-expr e)
  (second e))

(define (cdr? t)
  (tagged-tuple? 'cdr 2 t))

(define (cdr-expr e)
  (second e))

(define (pair?? t)
  (tagged-tuple? 'pair? 2 t))

(define (pair?-expr e)
  (second e))

(define (pair?-cons e)
  (list 'pair? e))


;; if

(define (if? t)
  (tagged-tuple? 'if 4 t))

(define (if-cons b t f)
  (list 'if b t f))

(define (if-cond e)
  (second e))

(define (if-then e)
  (third e))

(define (if-else e)
  (fourth e))

;; cond

(define (cond-clause? t)
  (and (list? t)
       (= (length t) 2)))

(define (cond-clause-cond c)
  (first c))

(define (cond-clause-expr c)
  (second c))

(define (cond-claue-cons b e)
  (list b e))

(define (cond? t)
  (and (tagged-list? 'cond t)
       (andmap cond-clause? (cdr t))))

(define (cond-clauses e)
  (cdr e))

(define (cond-cons cs)
  (cons 'cond cs))

;; lists

(define (my-null? t)
  (eq? t 'null))

(define (null?? t)
  (tagged-tuple? 'null? 2 t))

(define (null?-expr e)
  (second e))

(define (null?-cons e)
  (list 'null? e))

;; lambdas

(define (lambda? t)
  (and (tagged-tuple? 'lambda 3 t)
       (list? (cadr t))
       (andmap symbol? (cadr t))))

(define (lambda-cons vars e)
  (list 'lambda vars e))

(define (lambda-vars e)
  (cadr e))

(define (lambda-expr e)
  (caddr e))

;; lambda-rec

(define (lambda-rec? t)
  (and (tagged-tuple? 'lambda-rec 3 t)
       (list? (cadr t))
       (>= (length (cadr t)) 1)
       (andmap symbol? (cadr t))))

(define (lambda-rec-cons vars e)
  (list 'lambda-rec vars e))

(define (lambda-rec-expr e)
  (third e))

(define (lambda-rec-name e)
  (car (second e)))

(define (lambda-rec-vars e)
  (cdr (second e)))

;; applications

(define (app? t)
  (and (list? t)
       (> (length t) 0)))

(define (app-cons proc args)
  (cons proc args))

(define (app-proc e)
  (car e))

(define (app-args e)
  (cdr e))

;; expressions

(define (expr? t)
  (or (const? t)
      (and (op? t)
           (andmap expr? (op-args t)))
      (and (let? t)
           (expr? (let-expr t))
           (expr? (let-def-expr (let-def t))))
      (and (cons? t)
           (expr? (cons-fst t))
           (expr? (cons-snd t)))
      (and (car? t)
           (expr? (car-expr t)))
      (and (cdr? t)
           (expr? (cdr-expr t)))
      (and (pair?? t)
           (expr? (pair?-expr t)))
      (my-null? t)
      (and (null?? t)
           (expr? (null?-expr t)))
      (and (if? t)
           (expr? (if-cond t))
           (expr? (if-then t))
           (expr? (if-else t)))
      (and (cond? t)
           (andmap (lambda (c)
                      (and (expr? (cond-clause-cond c))
                           (expr? (cond-clause-expr c))))
                   (cond-clauses t)))
      (and (lambda? t)
           (expr? (lambda-expr t)))
      (and (lambda-rec? t)
           (expr? (lambda-rec-expr t)))
      (var? t)
      (and (app? t)
           (expr? (app-proc t))
           (andmap expr? (app-args t)))))

;; environments

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;; closures

(define (closure-cons xs expr env)
  (list 'closure xs expr env))

(define (closure? c)
  (and (list? c)
       (= (length c) 4)
       (eq? (car c) 'closure)))

(define (closure-vars c)
  (cadr c))

(define (closure-expr c)
  (caddr c))

(define (closure-env c)
  (cadddr c))

;; closure-rec

(define (closure-rec? t)
  (tagged-tuple? 'closure-rec 5 t))

(define (closure-rec-name e)
  (second e))

(define (closure-rec-vars e)
  (third e))

(define (closure-rec-expr e)
  (fourth e))

(define (closure-rec-env e)
  (fifth e))

(define (closure-rec-cons f xs e env)
  (list 'closure-rec f xs e env))

;; evaluator

(define (bool->val b)
  (if b 'true 'false))

(define (val->bool s)
  (cond [(eq? s 'true)  true]
        [(eq? s 'false) false]
        [else (error "could not convert symbol to bool")]))

(define (eval-env e env)
  (cond [(const? e)
         e]
        [(op? e)
         (apply (op->proc (op-op e))
                (map (lambda (a) (eval-env a env))
                     (op-args e)))]
        [(let? e)
         (eval-env (let-expr e)
                   (env-for-let (let-def e) env))]
        [(lazy-let? e) (eval-env (lazy-let->let e)
                                 env)]
        [(my-null? e)
         null]
        [(cons? e)
         (cons (eval-env (cons-fst e) env)
               (eval-env (cons-snd e) env))]
        [(car? e)
         (car (eval-env (car-expr e) env))]
        [(cdr? e)
         (cdr (eval-env (cdr-expr e) env))]
        [(pair?? e)
         (bool->val (pair? (eval-env (pair?-expr e) env)))]
        [(null?? e)
         (bool->val (null? (eval-env (null?-expr e) env)))]
        [(if? e)
         (if (val->bool (eval-env (if-cond e) env))
             (eval-env (if-then e) env)
             (eval-env (if-else e) env))]
        [(cond? e)
         (eval-cond-clauses (cond-clauses e) env)]
        [(var? e)
         (find-in-env (var-var e) env)]
        [(lambda? e)
         (closure-cons (lambda-vars e) (lambda-expr e) env)]
        [(lambda-rec? e)
         (closure-rec-cons (lambda-rec-name e)
                           (lambda-rec-vars e)
                           (lambda-rec-expr e)
                           env)]
        [(app? e)
         (apply-closure
           (eval-env (app-proc e) env)
           (map (lambda (a) (eval-env a env))
                (app-args e)))]))

(define (eval-cond-clauses cs env)
  (if (null? cs)
      (error "no true clause in cond")
      (let ([cond (cond-clause-cond (car cs))]
            [expr (cond-clause-expr (car cs))])
           (if (val->bool (eval-env cond env))
               (eval-env expr env)
               (eval-cond-clauses (cdr cs) env)))))

(define (apply-closure c args)
  (cond [(closure? c)
         (eval-env
            (closure-expr c)
            (env-for-closure
              (closure-vars c)
              args
              (closure-env c)))]
        [(closure-rec? c)
         (eval-env
           (closure-rec-expr c)
           (add-to-env
            (closure-rec-name c)
            c
            (env-for-closure
              (closure-rec-vars c)
              args
              (closure-rec-env c))))]))

(define (env-for-closure xs vs env)
  (cond [(and (null? xs) (null? vs)) env]
        [(and (not (null? xs)) (not (null? vs)))
         (add-to-env
           (car xs)
           (car vs)
           (env-for-closure (cdr xs) (cdr vs) env))]
        [else (error "arity mismatch")]))

(define (env-for-let def env)
  (add-to-env
    (let-def-var def)
    (eval-env (let-def-expr def) env)
    env))

(define (eval e)
  (eval-env e empty-env))


;;lazy-let

(define lazy-let-def? let-def?)
(define lazy-let-def let-def)
(define lazy-let-def-var let-def-var)
(define lazy-let-def-expr let-def-expr)
(define lazy-let-def-cons let-def-cons)
(define lazy-let-expr let-expr)

(define (lazy-let-cons def expr)
  (list 'lazy-let def expr))

(define (lazy-let? t)
  (and (tagged-tuple? 'lazy-let 3 t)
       (lazy-let-def? (cadr t))))

(define (lazy-let->let e)
  (define (transform t env)
    (cond [(null? t) null]
          [(lazy-let? t) (let-cons
                          (let-def-cons (lazy-let-def-var (lazy-let-def t)) ;;zmienna z definicji lazy-let
                                        (lambda-cons null ;;bezargumentowa lambda z przeksztalconym wyrazeniem z definicji
                                                     (transform (lazy-let-def-expr (lazy-let-def t)) env)))
                          (transform (lazy-let-expr t) ;;przeksztalcenie lazy-let-expr ze srodowiskiem powiekszonym o zmienna z definicji
                                     (add-to-env (lazy-let-def-var (lazy-let-def t)) ;;zmienna np. x
                                                 (list (lazy-let-def-var (lazy-let-def t))) ;;wartosc - (x)
                                                 env)))]
          [(let? t) (let-cons
                     (let-def-cons (let-def-var (let-def t))
                                   (transform (let-def-expr (let-def t))
                                              env))
                     (transform (let-expr t)
                                (add-to-env (let-def-var (let-def t))
                                            (let-def-var (let-def t))
                                            env)))]
          [(if? t) (if-cons (transform (if-cond t) env)
                            (transform (if-then t) env)
                            (transform (if-else t) env))]
          [(cond? t) (cond-cons (transform (cond-clauses t) env))]
          [(lambda? t) (lambda-cons (lambda-vars t)
                                    (transform (lambda-expr t) null))]
          ;;jesli transform natrafi w wyrazeniu na zmienna, to jezeli ta zmienna
          ;;byla w definicji lazy-let (czyli jest w srodowisku), to zwroc jej wartosc
          ;;(czyli np. dla zmiennej "x", zwroci "(x)"), a w przeciwnym wypadku zwroc niezmieniona zmienna
          [(var? t) (if (find-var-in-env t env)
                        (find-in-env t env)
                        t)]
          [(op? t) (cons (op-op t) (transform (op-args t) env))]
          [(list? t) (cons (transform (car t) env)
                           (transform (cdr t) env))]
          [(const? t) t]))

  (transform e null))

;;dokladnie to samo co find-in-env, z ta roznica, ze
;;find-var-in-env zwraca zmienna, a nie jej wartosc,
;;a w przypadku braku zmiennej w srodowisku zwraca falsz zamiast null
(define (find-var-in-env x env)
  (cond [(null? env) #f]
        [(eq? x (caar env)) (caar env)]
        [else (find-var-in-env x (cdr env))]))


;tests
(module+ tests
  (require rackunit)
  (and (eq? 5 (eval '(let [x 4]
                     (lazy-let [y (+ x 1)]
                     (let [x 10] y)))))
       ;;dzielenie przez 0
       (eq? 7 (eval '(lazy-let (x (/ 5 0)) 7)))
       ;;lazy-let z lambda z taka sama nazwa jednej zmiennej
       (eq? 14 (eval '(lazy-let (x 5) ;;x = 5 + 4 + y = 3 + z = 2
                                ((lambda (x y z) (+ x (lazy-let (y 4) y) y z)) x 3 2 ))))
       ;;silnia
       (eq? 120 (eval '((lambda-rec (fact n)
                                    (lazy-let [t 1]
                                    (lazy-let [f (* n (fact (- n 1)))]
                                              (if (= n 0) t f)))) 5)))
       ;;fibonacci
       (eq? 89 (eval '((lambda-rec (fib n)
                                   (lazy-let [t 1]
                                   (lazy-let [f (+ (fib (- n 1)) (fib (- n 2)))]
                                             (cond ((= n 1) t)
                                                   ((< n 1) 0)
                                                   (true f))))) 11)))
  )
  (display "Dzialanie lazy-let->let na kolejnych testach:\n")
  (lazy-let->let '(let [x 4]
                  (lazy-let [y (+ x 1)]
                  (let [x 10] y))))
  (display "Dosyc dlugie, reszta wykomentowana w testach\n")
;  (lazy-let->let '(lazy-let (x (/ 5 0)) 7))
;  (lazy-let->let '(lazy-let (x 5)
;                            ((lambda (x y z) (+ x (lazy-let (y 4) y) y z)) x 3 2 )))
;  (lazy-let->let '(lambda-rec (fact n)
;                             (lazy-let [t 1]
;                             (lazy-let [f (* n (fact (- n 1)))]
;                                       (if (= n 0) t f)))))
;  (lazy-let->let '(lambda-rec (fib n)
;                                   (lazy-let [t 1]
;                                   (lazy-let [f (+ (fib (- n 1)) (fib (- n 2)))]
;                                             (cond ((= n 1) t)
;                                                   ((< n 1) 0)
;                                                   (true f))))))
  )