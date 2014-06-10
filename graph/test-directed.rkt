#lang racket

(require "graph.rkt")
(require "search.rkt")

(define test-network
  (list
   (node 'node-1 '())
   (node 'node-2 '(node-1 node-3))
   (node 'node-3 '(node-1 node-2))
   (node 'node-4 '(node-3))
   (node 'node-5 '(node-1))))