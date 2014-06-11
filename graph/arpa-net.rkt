#lang racket

(require "graph.rkt")
(require "search.rkt")

(provide (all-defined-out))

(define SRI  (node 'sri  '(utah stan ucla ucsb)))
(define UCSB (node 'ucsb '(sri  ucla)))
(define UCLA (node 'ucla '(ucsb stan  sri rand)))
(define STAN (node 'stan '(sri  ucla)))
(define UTAH (node 'utah '(sri  sdc  mit)))
(define SDC  (node 'sdc  '(utah rand)))
(define RAND (node 'rand '(ucla bbn sdc)))
(define MIT  (node 'mit  '(utah bbn  linc)))
(define BBN  (node 'bbn  '(rand mit  harv)))
(define HARV (node 'harv '(bbn  carn)))
(define CARN (node 'carn '(harv case)))
(define CASE (node 'case '(carn linc)))
(define LINC (node 'linc '(case mit)))

(define ARPA-NET
  (list SRI
        UCSB
        UCLA
        STAN
        UTAH
        SDC
        RAND
        MIT
        BBN
        HARV
        CARN
        CASE
        LINC))