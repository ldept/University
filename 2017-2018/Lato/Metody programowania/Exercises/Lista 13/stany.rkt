#lang racket


(define (make-decrementer balance)
  (lambda (amount)
    (- balance amount)))


(define (make-simplified-withdraw balance)
  (lambda (amount)
    (set! balance (- balance amount))
    balance))

 (define D1 (make-decrementer 25))
 (define D2 (make-decrementer 25))
 
 (define W1 (make-simplified-withdraw 25))
 (define W2 (make-simplified-withdraw 25))
 
 (W1 20)
 (W1 20)
 (W2 20)


(define (factorial n)
  (let ((product 1)
        (counter 1))
    (define (iter)
      (if (> counter n)
          product
          (begin (set! product (* counter product))
                 (set! counter (+ counter 1))
                 (iter))))
    (iter)))
(define new-withdraw
  (let ((balance 100))
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))))

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch pass m)
    (if (eq? pass password)
        (cond ((eq? m 'withdraw) withdraw)
              ((eq? m 'deposit) deposit)
              (else (error "Unknown request -- MAKE-ACCOUNT"
                       m)))
        (display "Wrong password: ")))
  dispatch)

(define (make-cycle mlist)
  (define first mlist)
  (define (cycle ls)
    (if (null? (mcdr ls))
        (set-mcdr! ls mlist)
        (cycle (mcdr ls))))
  (if (null? mlist)
      (error "empty list")
      (cycle mlist)))

(define (has-cycle? mlist)
  
  (define (cycle w1 w2)
    (if (or (null? w2)
            (null? (mcdr w2)))
        #f
        (if (eq? (mcdr w1) (mcdr (mcdr w2)))
            #t
            (cycle (mcdr w1) (mcdr (mcdr w2)))))
          )
  (cycle mlist mlist))
(define mlist (mcons 0 (mcons 1 (mcons 2 null))))
(define acc (make-account 200 'admin))


(define (make-monitored f)
  (define counter 0)
  (define func
    (lambda arg
           (begin (set! counter (+ counter 1))
                  (apply f arg))))
  (define monitor
    (lambda (what)
      (cond [(eq? what 'how-many) counter ]
            [(eq? what 'reset) (set! counter 0)])))
    
  (cons func monitor))

;(define (bucket-sort ls)
;  (define v (make-vector (+ 1 (apply max ls)) 0))
;  (for-each (lambda (n) (vector-set! v (car n)

(define (lcons x f)
  (mcons x f))

(define (lhead l)
  (mcar l))

(define (ltail l)
  (when (procedure? (mcdr l))
      (set-mcdr! l ((mcdr l))))
  (mcdr l))


(define (ltake n l)
  (if (or (null? l) (= n 0))
      null
      (cons (lhead l)
            (ltake (- n 1) (ltail l)))))

(define (lfilter p l)
  (cond [(null? l) null]
        [(p (lhead l))
         (lcons (lhead l)
                (lambda ()
                  (lfilter p (ltail l))))]
        [else (lfilter p (ltail l))]))

(define (lmap f . ls)
  (if (ormap null? ls) null
      (lcons (apply f (map lhead ls))
             (lambda ()
               (apply lmap (cons f (map ltail ls)))))))

;; ciąg Fibonacciego

(define fib
  (lcons 0
         (lambda ()
           (lcons 1
                  (lambda ()
                    (lmap + fib (ltail fib)))))))
(define (integers-starting-from n)
  (lcons n (lambda () (integers-starting-from (+ n 1)))))
(define factorials
  (lcons 1
         (lambda ()
           (lcons 1
                  (lambda ()
                    (lmap * (integers-starting-from 2) (ltail factorials)))))))

(define (part-sum ls)
  (define result
  (lcons 0      
         (lambda ()
           (lmap + ls result))))
  result)

(define (merge xs ys)
  (cond [(< (lhead xs) (lhead ys))
             (lcons (lhead xs)
                    (lambda ()
                      (merge (ltail xs) ys)))]
        [(> (lhead xs) (lhead ys))
             (lcons (lhead ys)
                    (lambda ()
                      (merge xs (ltail ys))))]
        [else (lcons (lhead xs)
                      (lambda()
                        (merge (ltail xs) (ltail ys))))]))
(define num2
    (lcons 2
           (lambda () (lmap (lambda (x) (+ x 2)) num2))))
  (define num3
    (lcons 3
           (lambda () (lmap (lambda (x) (+ x 3)) num3))))
  (define num5
    (lcons 5
           (lambda () (lmap (lambda (x) (+ x 5)) num5))))

(define num235
    (merge (merge num2 num3) num5))
  
  