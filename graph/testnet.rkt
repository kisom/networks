#lang racket

(require "graph.rkt")
;(require "undirected.rkt")
(require "search.rkt")

(define node-1 (node 'node-1 '(node-2 node-4)))
(define node-2 (node 'node-2 '(node-1 node-3)))
(define node-3 (node 'node-3 '(node-2 node-4)))
(define node-4 (node 'node-4 '(node-3 node-1)))
(define node-5 (node 'node-5 '()))
(define network (list node-1 node-2 node-3 node-4 node-5))

(bfs network 'node-2 'node-4)
(connected? network)
(set! network (reverse (rest (reverse network))))
(connected? network)
