#lang racket

(require "graph.rkt")

(provide bfs
         connected?
         minimise-path)

(define (build-path nodes)
  (define (path-search nodes path)
    (cond
      [(empty? nodes) #f]
      [(empty? (rest nodes)) (reverse (cons (first nodes) path))]
      [else
       (if (neighbours? (first nodes) (second nodes))
           (path-search (rest nodes) (cons (first nodes) path))
           (path-search (rest nodes) path))]))
  (let ([path (path-search (rest nodes) (list (first nodes)))])
    (if path
        (minimise-path path)
        path)))

(define (minimise-path nodes)
  (define (equivalent-path? path)
    (and (path? path)
         (equal? (node-label (first nodes))
                 (node-label (first path)))
         (equal? (node-label (last nodes))
                 (node-label (last path)))))
  (define (shorten-path nodes path)
    (if (empty? nodes)
        path
        (if (empty? (rest nodes))
            (reverse (cons (first nodes) path))
            (let* ([neighbours (filter (λ (o)
                                         (neighbours? (first nodes) o))
                                       (rest nodes))]
                   [farthest (last neighbours)])
                   (shorten-path (memf (λ (o)
                                         (equal? (node-label o)
                                                 (node-label farthest)))
                                       (rest nodes))
                                 (cons (first nodes) path))))))
  (let ([path (shorten-path nodes '())])
    (if (equivalent-path? path)
        path
        nodes)))

(define (bfs network start end)
  (let ([start-node (get-node network start)]
        [end-node   (get-node network end)])
    (when (not start-node)
      (error start "not found in network."))
    (when (not end-node)
      (error end "not found in network."))
    (define (search queue seen path)
      (if (empty? queue)
          #f
          (let ([t (first queue)]
                [queue (rest queue)])
            (if (equal? t end)
                (append (reverse path) (list t))
                (let ([edges (filter-not (λ (nd)
                                           (member nd seen))
                                         (set->list
                                          (node-edges
                                           (get-node network t))))])
                  (search (append edges queue)
                          (cons t seen)
                          (cons t path)))))))
    (let ([path (search (list start) '() '())])
      (if path
          (let ([path (map (λ (nd)
                             (get-node network nd))
                           path)])
            (build-path path))
          #f))))

(define (dfs network start-label end-label)
  (let ([start-node (get-node network start-label)]
        [end-node   (get-node network end-label)])
    (when (not start-node)
      (error start-label "not found in network."))
    (when (not end-node)
      (error end-label "not found in network."))
    (define (search s seen)
      (printf "Search: stack is ~v; seen is ~v~%" s seen)
      (if (empty? s)
          #f
          (let ([v (first s)]
                [s (rest s)])
            (if (equal? v end-label)
                (reverse (cons v s))
                (if (member v seen)
                    (search s seen)
                    (search (set->list
                             (set-union
                              (node-edges
                               (get-node network v))
                              (list->set (append s (list v)))))
                            (cons v seen)))))))
    (let ([path (search (list start-label) '())])
      (if (path? (map (λ (nd)
                        (get-node network nd))
                      path))
          path
          (error "Not a path:" path)))))


(define (connected? network)
  (foldl (λ (x y)
           (and x y))
         #t
         (map (λ (nd)
                (andmap (λ (o)
                          (bfs network (node-label nd) (node-label o)))
                        (filter-not (λ (o)
                                      (equal? (node-label o)
                                              (node-label nd)))
                                    network)))
              network)))
