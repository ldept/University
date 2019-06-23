#lang racket

;; arithmetic expressions

(define (const? t)
  (number? t))


(define (if-zero? e)
  (and (list? e)
       (= (length e) 4)
       (eq? (car e) 'if-zero)))
(define (if-zero-true e)
  (caddr e))
(define (if-zero-false e)
  (cadddr e))
(define (if-zero-expr e)
  (cadr e))
(define (cons-if-zero e t f)
  (list 'if-zero e t f))
(define (binop? t)
  (and (list? t)
       (= (length t) 3)
       (member (car t) '(+ - * /))))

(define (binop-op e)
  (car e))

(define (binop-left e)
  (cadr e))

(define (binop-right e)
  (caddr e))

(define (binop-cons op l r)
  (list op l r))

(define (arith-expr? t)
  (or (const? t)
      (and (binop? t)
           (arith-expr? (binop-left  t))
           (arith-expr? (binop-right t)))))

;; calculator

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]))

(define (eval-arith e)
  (cond [(const? e) e]
        [(binop? e)
         ((op->proc (binop-op e))
            (eval-arith (binop-left  e))
            (eval-arith (binop-right e)))]))

;; let expressions

;;cw. 8 konwersja na indeksy De Bruijna
(define (let->let-db env e)
  (cond [(const? e) e]
        [(binop? e) (binop-cons (binop-op e)
                                (let->let-db env (binop-left e))
                                (let->let-db env (binop-right e)))]
        [(var? e) (index-cons (get-index env e))]
        [(let? e) (db-let-cons
                   (let->let-db env (let-expr1 e))
                   (let->let-db (env-ext env (let-var1 e))
                                (let-expr2 e)))]))
(define (env-ext env x)
  (cons x env))

(define (get-index env x)
  (if (null? env)
      (error "undefined" x)
      (if (eq? x (car env))
          0
          (1 + (get-index (cdr env))))))
      
  
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
      (and (binop? t)
           (arith/let-expr? (binop-left  t))
           (arith/let-expr? (binop-right t)))
      (and (let? t)
           (arith/let-expr? (let-expr t))
           (arith/let-expr? (let-def (let-def-expr t))))
      (var? t)))

;; evalation via substitution

(define (subst e x f)
  (cond [(const? e) e]
        [(binop? e)
         (binop-cons
           (binop-op e)
           (subst (binop-left  e) x f)
           (subst (binop-right e) x f))]
        [(let? e)
         (let-cons
           (let-def-cons
             (let-def-var (let-def e))
             (subst (let-def-expr (let-def e)) x f))
           (if (eq? x (let-def-var (let-def e)))
               (let-expr e)
               (subst (let-expr e) x f)))]
        [(if-zero? e) (cons-if-zero
                       (subst (if-zero-expr e) x f)
                       (subst (if-zero-true e) x f)
                       (subst (if-zero-false e) x f))]
        [(var? e)
         (if (eq? x (var-var e))
             f
             (var-var e))]))

(define (eval-subst e)
  (cond [(const? e) e]
        [(binop? e)
         ((op->proc (binop-op e))
            (eval-subst (binop-left  e))
            (eval-subst (binop-right e)))]
        [(let? e)
         (eval-subst
           (subst
             (let-expr e)
             (let-def-var (let-def e))
             (eval-subst (let-def-expr (let-def e)))))]
        [(if-zero? e)
         (if (= (eval-subst (if-zero-expr e)) 0)
             (eval-subst (if-zero-true e))
             (eval-subst (if-zero-false e)))]
        [(var? e)
         (error "undefined variable" (var-var e))]))

;; evaluation via environments

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

(define (eval-env e env)
  (cond [(const? e) e]
        [(binop? e)
         ((op->proc (binop-op e))
            (eval-env (binop-left  e) env)
            (eval-env (binop-right e) env))]
        [(let? e)
         (eval-env
           (let-expr e)
           (env-for-let (let-def e) env))]
        [(if-zero? e) (if (= (eval-env (if-zero-expr e) env) 0)
                          (eval-env (if-zero-true e) env)
                          (eval-env (if-zero-false e) env))]
        [(var? e) (find-in-env (var-var e) env)]))

(define (env-for-let def env)
  (add-to-env
    (let-def-var def)
    (eval-env (let-def-expr def) env)
    env))

(define (eval e)
  (eval-env e empty-env))

(define (arith->onp e)
  (cond [(const? e) (list e)] 
        [(binop? e) (append (arith->onp (binop-left e))
                             (arith->onp (binop-right e))
                             (list (binop-op e)))]))
(define (arith->rpn e acc)
  (cond [(const? e) (cons e acc)]
        [(binop? e) (arith->rpn (binop-left e)
                                (arith->rpn (binop-right e)
                                            (cons (binop-op e) acc)))]))