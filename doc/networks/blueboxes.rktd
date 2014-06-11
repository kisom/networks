1171
((3) 0 () 3 ((q lib "networks/graph/graph.rkt") (q 0 . 4) (q lib "networks/graph/search.rkt")) () (h ! (equal) ((c def c (c (? . 2) q connected?)) q (2018 . 3)) ((c def c (c (? . 0) q simple-path?)) q (458 . 3)) ((c def c (c (? . 0) q node-label)) c (q 97 . 3) c (? . 1)) ((c def c (c (? . 0) q struct:node)) c (? . 1)) ((c def c (c (? . 0) q node)) c (? . 1)) ((c def c (c (? . 0) q get-node)) q (799 . 4)) ((c def c (c (? . 0) q cycle?)) q (543 . 3)) ((c def c (c (? . 0) q node?)) c (q 239 . 3) c (? . 1)) ((c def c (c (? . 0) q link/undirected)) q (707 . 4)) ((c def c (c (? . 0) q node-edges)) c (q 160 . 3) c (? . 1)) ((c def c (c (? . 2) q clean-path)) q (2099 . 3)) ((c def c (c (? . 0) q link/directed)) q (622 . 4)) ((c def c (c (? . 0) q directed-network?)) q (1478 . 3)) ((c def c (c (? . 0) q following)) q (1162 . 5)) ((c def c (c (? . 2) q dfs)) q (1793 . 7)) ((c def c (c (? . 0) q followers)) q (1021 . 5)) ((c def c (c (? . 0) q neighbours?)) q (294 . 4)) ((c def c (c (? . 0) q get-node-map)) q (925 . 3)) ((c def c (c (? . 0) q path?)) q (380 . 3)) ((c def c (c (? . 0) q sort-by-followers)) q (1303 . 6)) ((c def c (c (? . 2) q bfs)) q (1568 . 7))))
struct
(struct node (label edges))
  label : symbol?
  edges : (setof (all/c symbol?))
procedure
(node-label node) -> (symbol?)
  node : node?
procedure
(node-edges node) -> (setof (all/c symbol?))
  node : node?
procedure
(node? id) -> (boolean?)
  id : any/c
procedure
(neighbours? from to) -> (boolean?)
  from : node?
  to : node?
procedure
(path? path) -> (boolean?)
  path : (listof (all/c node?))
procedure
(simple-path? path) -> (boolean?)
  path : (listof (all/c node?))
procedure
(cycle? path) -> (boolean?)
  path : (listof (all/c node?))
procedure
(link/directed from to) -> (node?)
  from : node?
  to : node?
procedure
(link/undirected from to) -> node? node?
  from : node?
  to : node?
procedure
(get-node network label) -> (or/c node? void?)
  network : (listof (all/c node?))
  label : symbol?
procedure
(get-node-map network) -> (lambda node?)
  network : (listof (all/c node?))
procedure
(followers network node)
 -> (and/c integer? (or/c zero? positive?))
  network : (list-of (node?))
  node : node?
procedure
(following network node)
 -> (and/c integer? (or/c zero? positive?))
  network : (list-of (node?))
  node : node?
procedure
(sort-by-followers network)
 -> (list-of
     (pair? (and/c integer? (or/c zero? positive?))
            node?))
  network : (list-of (node?))
procedure
(directed-network? network) -> (boolean?)
  network : (list-of (node?))
procedure
(bfs network start end) -> (or/c
                            (and/c (list-of node?) path?)
                            (empty?))
  network : (listof (node?))
  start : symbol?
  end : symbol?
procedure
(dfs network start end) -> (or/c
                            (and/c (list-of node?) path?)
                            (empty?))
  network : (listof (node?))
  start : symbol?
  end : symbol?
procedure
(connected? network) -> (boolean?)
  network : (list-of node?)
procedure
(clean-path path) -> (list-of (node?))
  path : (list-of (node?))
