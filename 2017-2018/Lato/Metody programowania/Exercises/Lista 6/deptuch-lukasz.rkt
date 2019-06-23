#lang racket

(define (const? t)
  (number? t))

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

(define (hole? t)
  (eq? t 'hole))

(define (arith/let/holes? t)
  (or (hole? t)
      (const? t)
      (and (binop? t)
           (arith/let/holes? (binop-left  t))
           (arith/let/holes? (binop-right t)))
      (and (let? t)
           (arith/let/holes? (let-expr t))
           (arith/let/holes? (let-def-expr (let-def t))))
      (var? t)))

(define (num-of-holes t)
  (cond [(hole? t) 1]
        [(const? t) 0]
        [(binop? t)
         (+ (num-of-holes (binop-left  t))
            (num-of-holes (binop-right t)))]
        [(let? t)
         (+ (num-of-holes (let-expr t))
            (num-of-holes (let-def-expr (let-def t))))]
        [(var? t) 0]))

(define (arith/let/hole-expr? t)
  (and (arith/let/holes? t)
       (= (num-of-holes t) 1)))

(define (hole-context e)
  ;; TODO: zaimplementuj!
  (define (find-context expr context)
    (cond [(hole? expr) context]
          [(binop? expr)
           ;;jezeli wyrazenie jest operatorem binarnym, to jezeli dziura jest w jego lewym argumencie
           ;;to szukamy dziury/kontekstu w jego lewej czesci, wpp musi byc w prawej
           ;;(bo binop ma tylko 2 argumenty - "lewy" i "prawy", a wyrazenie musi spelniac arith/let/hole-expr?, czyli w ktoryms z arg. musi byc dziura)
           (if (arith/let/hole-expr? (binop-left expr))
               (find-context (binop-left expr) context)
               (find-context (binop-right expr) context))]
          
          [(let? expr)
           ;;jezeli dziura jest w definicji leta to musi byc w let-def-expr
           ;;wtedy wyszukujemy jej tam z niezmienionym kontekstem
           ;;wpp musi byc w let-expr, wtedy wyszukujemy z kontekstem powiekszonym o
           ;;zmienna zwiazana w definicji leta (let-def-var)
           (if (arith/let/hole-expr? (let-def-expr (let-def expr)))
               (find-context (let-def-expr (let-def expr)) context)
               (find-context (let-expr expr)
                             (let ((var (let-def-var (let-def expr))))
                               ;;jezeli zmienna jest juz w kontekscie to go nie zmieniamy
                               ;;wpp dodajemy ta zmienna do kontekstu
                               (if (member var context)
                                   context
                                   (cons var context)))))]))
  (find-context e null))

(define (test)
  ;; TODO: zaimplementuj!
  (and (equal? (hole-context 'hole) '())
       (equal? (hole-context '(+ 3 hole)) '())
       (equal? (hole-context '(+ hole 3)) '())
       (or equal? (hole-context '(let (x 3) (let (y 7) (+ x hole)))) '(y x)
           equal? (hole-context '(let (x 3) (let (y 7) (+ x hole)))) '(x y))
       (equal? (hole-context '(let (x 3) (let (y hole) (+ x 3)))) '(x))
       (equal? (hole-context '(let (x hole) (let (y 7) (+ x 3)))) '())
       (equal? (hole-context '(+ (let (x 4) 5) hole)) '())
       (equal? (hole-context '(/ (let (x (let (y hole) (+ 41 1))) 42) 42)) '())
       (equal? (hole-context '(- (let (x (let (y 20) (+ hole 4))) 5) 12)) '(y))))
