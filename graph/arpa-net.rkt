#lang racket

(require "graph.rkt")
(require "search.rkt")

(define ARPA-NET
  (list
   (node 'sri  '(utah stan ucla ucsb))
   (node 'ucsb '(sri  ucla))
   (node 'ucla '(ucsb stan  sri rand))
   (node 'stan '(sri  ucla))
   (node 'utah '(sri  sdc  mit))
   (node 'sdc  '(utah rand))
   (node 'rand '(ucla bbn))
   (node 'mit  '(utah bbn  linc))
   (node 'bbn  '(rand mit  harv))
   (node 'harv '(bbn  carn))
   (node 'carn '(harv case))
   (node 'case '(carn linc))
   (node 'linc '(case mit))))
