#lang racket

;; sygnatura: grafy
(define-signature graph^
  ((contracted
    [graph        (-> list? (listof edge?) graph?)]
    [graph?       (-> any/c boolean?)]
    [graph-nodes  (-> graph? list?)]
    [graph-edges  (-> graph? (listof edge?))]
    [edge         (-> any/c any/c edge?)]
    [edge?        (-> any/c boolean?)]
    [edge-start   (-> edge? any/c)]
    [edge-end     (-> edge? any/c)]
    [has-node?    (-> graph? any/c boolean?)]
    [outnodes     (-> graph? any/c list?)]
    [remove-node  (-> graph? any/c graph?)]
    )))

;; prosta implementacja grafów
(define-unit simple-graph@
  (import)
  (export graph^)

  (define (graph? g)
    (and (list? g)
         (eq? (length g) 3)
         (eq? (car g) 'graph)))

  (define (edge? e)
    (and (list? e)
         (eq? (length e) 3)
         (eq? (car e) 'edge)))

  (define (graph-nodes g) (cadr g))

  (define (graph-edges g) (caddr g))

  (define (graph n e) (list 'graph n e))

  (define (edge n1 n2) (list 'edge n1 n2))

  (define (edge-start e) (cadr e))

  (define (edge-end e) (caddr e))

  (define (has-node? g n) (not (not (member n (graph-nodes g)))))
  
  (define (outnodes g n)
    (filter-map
     (lambda (e)
       (and (eq? (edge-start e) n)
            (edge-end e)))
     (graph-edges g)))

  (define (remove-node g n)
    (graph
     (remove n (graph-nodes g))
     (filter
      (lambda (e)
        (not (eq? (edge-start e) n)))
      (graph-edges g)))))

;; sygnatura dla struktury danych
(define-signature bag^
  ((contracted
    [bag?       (-> any/c boolean?)]
    [empty-bag  (and/c bag? bag-empty?)]
    [bag-empty? (-> bag? boolean?)]
    [bag-insert (-> bag? any/c (and/c bag? (not/c bag-empty?)))]
    [bag-peek   (-> (and/c bag? (not/c bag-empty?)) any/c)]
    [bag-remove (-> (and/c bag? (not/c bag-empty?)) bag?)])))

;; struktura danych - stos
(define-unit bag-stack@
  (import)
  (export bag^)
  
  (define bag? list?)
  (define bag-empty? null?)
  (define empty-bag null)
  
  (define (bag-insert bag x)
    (cons x bag))
  (define (bag-peek bag)
    (car bag))
  (define (bag-remove bag)
    (cdr bag))

;; TODO: zaimplementuj stos
)

;; struktura danych - kolejka FIFO
;; do zaimplementowania przez studentów
(define-unit bag-fifo@
  (import)
  (export bag^)
  
  (define (queue-cons xs ys)
    (if (null? ys)
        (list null (reverse xs))
        (list xs ys)))
  (define (queue-in queue)
    (first queue))
  (define (queue-out queue)
    (second queue))
  
  (define (bag? x)
    (and (list? x)
         (= 2 (length x))
         (list? (queue-in x))
         (list? (queue-out x))))
  
  (define (bag-empty? bag)
    (and (null? (queue-in bag))
         (null? (queue-out bag))))
  
  (define empty-bag
    (queue-cons null null))
  
  (define (bag-peek bag)
    (car (queue-out bag)))
  
  (define (bag-insert bag x)
    (queue-cons (cons x (queue-in bag)) (queue-out bag)))

  (define (bag-remove bag)
    (queue-cons (queue-in bag) (cdr (queue-out bag))))
    
  
;; TODO: zaimplementuj kolejkę
)

;; sygnatura dla przeszukiwania grafu
(define-signature graph-search^
  (search))

;; implementacja przeszukiwania grafu
;; uzależniona od implementacji grafu i struktury danych
(define-unit/contract graph-search@
  (import bag^ graph^)
  (export (graph-search^
           [search (-> graph? any/c (listof any/c))]))
  (define (search g n)
    (define (it g b l)
      (cond
        [(bag-empty? b) (reverse l)]
        [(has-node? g (bag-peek b))
         (it (remove-node g (bag-peek b))
             (foldl
              (lambda (n1 b1) (bag-insert b1 n1))
              (bag-remove b)
              (outnodes g (bag-peek b)))
             (cons (bag-peek b) l))]
        [else (it g (bag-remove b) l)]))
    (it g (bag-insert empty-bag n) '()))
  )

;; otwarcie komponentu grafu
(define-values/invoke-unit/infer simple-graph@)

;; graf testowy
(define test-graph
  (graph
   (list 1 2 3 4)
   (list (edge 1 3)
         (edge 1 2)
         (edge 2 4))))
;; TODO: napisz inne testowe grafy!

(define test-graph-1
  (graph
   (list 1 2)
   (list (edge 1 1)
         (edge 2 1))))

(define test-graph-2
  (graph
   (list 1 2 3 4 5)
   (list (edge 1 3)
         (edge 3 2)
         (edge 3 4)
         (edge 4 5))))
(define test-graph-3
  (graph
   (list 1 2 3 4 5 6)
   (list (edge 1 2)
         (edge 2 3)
         (edge 3 3)
         (edge 4 5)
         (edge 5 6)
         (edge 4 4))))
;; otwarcie komponentu stosu
(define-values/invoke-unit/infer bag-stack@)
;; opcja 2: otwarcie komponentu kolejki
;(define-values/invoke-unit/infer bag-fifo@)

;; testy w Quickchecku
(require quickcheck)

;; test przykładowy: jeśli do pustej struktury dodamy element
;; i od razu go usuniemy, wynikowa struktura jest pusta
(quickcheck
 (property ([s arbitrary-symbol])
           (bag-empty? (bag-remove (bag-insert empty-bag s)))))
;; TODO: napisz inne własności do sprawdzenia!
;; jeśli jakaś własność dotyczy tylko stosu lub tylko kolejki,
;; wykomentuj ją i opisz to w komentarzu powyżej własności

;; jesli dodamy element do pustego stosu to
(quickcheck
 (property ([s arbitrary-symbol])
           (eq? (bag-peek (bag-insert empty-bag s))
                s)))

(quickcheck
 (property ([s1 arbitrary-symbol]
            [s2 arbitrary-symbol])
           (equal? (bag-insert empty-bag s1)
                   (bag-remove (bag-insert (bag-insert empty-bag s1) s2)))))

;;@fifo - zamieniona kolejnosc
;(quickcheck
; (property ([s1 arbitrary-symbol]
;            [s2 arbitrary-symbol])
;           (equal? (bag-insert empty-bag s1)
;                   (bag-remove (bag-insert (bag-insert empty-bag s2) s1)))))

;; otwarcie komponentu przeszukiwania
(define-values/invoke-unit/infer graph-search@)

;; uruchomienie przeszukiwania na przykładowym grafie
(search test-graph 1)
;; TODO: uruchom przeszukiwanie na swoich przykładowych grafach!
(search test-graph-1 1)
(search test-graph-2 1)
(search test-graph-3 1)