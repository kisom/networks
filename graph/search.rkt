#lang racket

(require "graph.rkt")

(provide bfs
         dfs
         connected?
         clean-path)

(define (clean-path nodes)
  (define (path-search nodes path)
    (cond
      [(empty? nodes) '()]
      [(empty? (rest nodes)) (reverse (cons (first nodes) path))]
      [else
       (if (neighbours? (first nodes) (second nodes))
           (path-search (rest nodes) (cons (first nodes) path))
           (path-search (rest nodes) path))]))
  (if (empty? nodes)
      '()
      (let ([path (path-search (rest nodes) (list (first nodes)))])
        (if path
            (minimise-path path)
            path))))

(define (minimise-path nodes)
  (define (equivalent-path? path)
    (and (not (empty? nodes))
         (not (empty? path))
         (path? path)
         (equal? (node-label (first nodes))
                 (node-label (first path)))
         (equal? (node-label (last nodes))
                 (node-label (last path)))))
  (define (shorten-path nodes path)
    (if (empty? nodes)
        path
        (if (empty? (rest nodes))
            (reverse (cons (first nodes) path))
            (let ([neighbours (filter (λ (o)
                                        (neighbours? (first nodes) o))
                                      (rest nodes))])
              (if (empty? neighbours)
                  '()
                  (let ([farthest (last neighbours)])
                    (shorten-path (memf (λ (o)
                                          (equal? (node-label o)
                                                  (node-label farthest)))
                                        (rest nodes))
                                  (cons (first nodes) path))))))))
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
          '()
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
          (clean-path (map (λ (nd) (get-node network nd)) path))
          #f))))


(define (dfs network start end)
  (let ([start-node (get-node network start)]
        [end-node   (get-node network end)])
    (when (not start-node)
      (error start "not found in network."))
    (when (not end-node)
      (error end "not found in network."))
    (define (search stack seen path)
      (if (empty? stack)
          '()
          (let ([i (first stack)]
                [stack (rest stack)])
            (if (equal? i end)
                (cons i path)
                (search (append 
                         (filter-not (λ (edge)
                                       (member edge seen))
                                     (set->list
                                      (node-edges
                                       (get-node network i))))
                         stack)
                        (cons i seen)
                        (cons i path))))))
    (let ([path (search (list start) '() '())])
      (let ([path (map (get-node-map network) (reverse path))])
        (clean-path path)))))

(define (node-connected? network node)
  (andmap (λ (o)
            (not (empty? (bfs network (node-label node) (node-label o)))))
          (filter-not (λ (o)
                        (equal? (node-label o)
                                (node-label node)))
                      network)))

(define (connected? network)
  (foldl (λ (x y)
           (and x y))
         #t
         (map (λ (node)
                (node-connected? network node))
              network)))
