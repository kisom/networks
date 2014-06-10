#lang racket

(provide node
         node?
         node-label
         node-edges
         path?
         simple-path?
         cycle?
         neighbours?
         link
         get-node
         followers
         following
         sort-by-followers
         directed-network?)

(struct node (label edges)
  #:transparent
  #:guard (λ (label edges type-name)
            (cond
              [(and (symbol? label)
                    (or (list? edges)
                        (set?  edges))
                    (if (list? edges)
                        (andmap symbol? edges)
                        (foldr (λ (x y)
                                 (and x y))
                               #t
                               (set-map edges symbol?))))
               (values label
                       (if (list? edges)
                           (list->set edges)
                           edges))]
              [else (error "Node labels must be symbols."
                           label edges)])))

(define (neighbours? node-1 node-2)
  (set-member? (node-edges node-1) (node-label node-2)))

(define (link/undirected node-1 node-2)
  (values
   (node (node-label node-1) (set-add (node-edges node-1) (node-label node-2)))
   (node (node-label node-2) (set-add (node-edges node-2) (node-label node-1)))))

(define (link/directed node-1 node-2)
  (node (node-label node-1) (set-add (node-edges node-1) (node-label node-2))))

(define (path? network)
  (cond
    [(not (list? network)) (error "Network should be a list of nodes, not " network)]
    [(empty? network) #t]
    [(empty? (rest network)) #t]
    [(neighbours? (first network) (second network))
     (path? (rest network))]
    [else #f]))

(define (simple-path? network)
  (and (path? network)
       (equal?
        (length network)
        (set-count (list->set network)))))

(define (cycle? network)
  (and (path? network)
       (eqv? (first network) (last network))))

(define (get-node network label)
  (if (symbol? label)
      (findf (λ (nd)
               (equal? (node-label nd)
                       label))
             network)
      (error "Node labels must be symbols.")))

(define (followers network node)
  (let ([nd (if (symbol? node)
                (get-node network node)
                node)])
    (if nd
        (set-count
         (edges-into network node))
        0)))

(define (following network node)
  (let ([nd (if (symbol? node)
                (get-node network node)
                node)])
    (set-count
     (node-edges nd))))

(define (sort-by-followers network)
  (define (ranking nd o)
    (> (followers network nd)
       (followers network o)))
  (map (λ (node)
         (cons (followers network node) node))
       (sort network ranking)))

(define (all? lst)
  (foldl (λ (x y)
           (and x y))
         #t
         lst))

(define (none? lst)
  (not
   (all? lst)))

(define (edges-into network node)
  (list->set
   (map node-label
        (filter (λ (o)
                  (neighbours? o node))
                network))))

(define (directed-node? network node)
  (not
   (set-empty?
    (set-symmetric-difference
     (node-edges node)
     (edges-into network node)))))

(define (directed-network? network)
  (andmap (λ (node) (directed-node? network node)) network))

