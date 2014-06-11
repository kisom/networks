#lang info

(define collection 'multi)
(define blurb '("Utilities for exploring network analysis."))
(define name "Graph theory network utilities")
(define deps '("racket"))
(define pkg-desc "Utility code for dealing with networks.")
(define pkg-authors '(kyle))
(define categories '(datastructures misc))
(define release-notes '("In-progress package to learn how to package software for PLaneT."))
(define repositories '("4.x"))
(define primary-file '("graph/graph.rkt" "graph/search.rkt"))
(define scribblings '(("scribblings/networks.scrbl" (multi-page))))