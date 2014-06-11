#lang scribble/manual

@require[scribble/eval]
@require[(for-label networks/graph/graph)]
@require[(for-label networks/graph/search)]
@provide[all-defined-out]


@(define networks-eval (make-base-eval))
@;interaction-eval[#:eval networks-eval (require networks/graph/graph)]
@(networks-eval '(require racket))
@(networks-eval '(require networks/graph/graph))
@(networks-eval '(require networks/graph/search))

@title[#:style '(toc)]{networks}
@local-table-of-contents[]

Networks is a collection of tools for exploring network analysis,
particularly in the context of social network analysis. It was
inspired during the course of reading
@hyperlink["https://www.cs.cornell.edu/home/kleinber/networks-book/"]{Networks,
Crowds, and Markets}. This documentation will serve as my notes and
discussion on network analysis, as well as containing the
documentation for the package.

@section[#:tag "package"]{The @code{networks} Software}
@subsection[#:tag "graph"]{graph}

The @code{graph} package actually contains two submodules:
@code{graph} and @code{search}. The former contains utilities for
manipulating a graph, while the latter contains utilities for
searching a graph.

@subsubsection[#:tag "graph-graph"]{graph}
@defmodule[networks/graph/graph]

@code["graph"] is a utility collection that handles the definition of
basic networks. There are two components: graph creation and graph
searching. Networks are represented as a list of @racket[node]s.

@defstruct*[node ([label symbol?] [edges (setof (all/c symbol?))])]{

The @racket[node] is the core structure used in this package. Every
node has a label, which @bold{must} be unique in whatever networks
this node appears in. The node’s edges will be stored as a set
internally. The symbols in the edges should refer to labels of nodes
in the network. When creating a node, the edges may be passed in as a
list, in which case the list will be converted to a set using
@racket[list->set].

For example, here is a representation of the early 13-node ARPA
network:

@examples[#:eval networks-eval
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
]
}

@defproc[(node-label [node node?])
         (symbol?)]{

@racket[node-label] returns the label for the node, which is a
symbol. This identifier should be used in referring to the node in the
edges of other nodes.

@examples[#:eval networks-eval
(node-label MIT)
]
}
@defproc[(node-edges [node node?])
         (setof (all/c symbol?))
]{

@racket[node-edges] returns a list of the @racket[node]'s edges; these
will all be symbols that should refer to nodes in the same network.

@examples[#:eval networks-eval
(node-edges MIT)
]
}

@defproc[(node? [id any/c]) (boolean?)]{

@racket[node?] is a predicate returning true if the identifier names
@racket[node].

@examples[#:eval networks-eval
(node? MIT)
(node? (node-label MIT))
]
}

@defproc[(neighbours? [from node?] [to node?]) (boolean?)]{

@racket[neighbours?] is a predicate that returns true if @code{to}'s
label appears in @code{from}'s edges.

@examples[#:eval networks-eval
(define node-1 (node 'node-1 '(node-2 node-3)))
(define node-2 (node 'node-2 '(node-1 node-3)))
(define node-3 (node 'node-3 '(node-2)))
(neighbours? node-1 node-2)
(neighbours? node-2 node-1)
(neighbours? node-1 node-3)
(neighbours? node-3 node-1)
]}

@defproc[(path? [path (listof (all/c node?))]) (boolean?)]{

@racket[path?] returns true if an @italic{path} exists between the
nodes in the network. That is, each node is a neighbour of the next
node in the list (excluding the last node, which ends the path.)

@examples[#:eval networks-eval
(path? (list node-1 node-2 node-3))
(path? (list node-1 node-3 node-2))
(path? (list node-3 node-1 node-2))
]
}

@defproc[(simple-path? [path (listof (all/c node?))]) (boolean?)]{

A path is said to be a @italic{simple path} when no node appears more
than once in the path.

@examples[#:eval networks-eval
(path? (list node-1 node-2 node-1 node-3))
(simple-path? (list node-1 node-2 node-1 node-3))
(path? (list node-1 node-2 node-3))
(simple-path? (list node-1 node-2 node-3))
]}

@defproc[(cycle? [path (listof (all/c node?))]) (boolean?)]{

A @italic{cycle} exists when a path starts and ends on the same
@racket[node].

@examples[#:eval networks-eval
(cycle? (list node-3 node-2 node-1 node-3))
(cycle? (list node-1 node-2 node-3))
]
}

@defproc[(link/directed [from node?] [to node?]) (node?)]{

@racket[link/directed] creates an edge between @code{from} and
@code{to}; as it is a directed link, it will only be created one-way.
Linking is non-destructive, and returns a new @racket[node] with
@code{to} in its set of edges. If the two nodes were already linked,
nothing happens.

@examples[#:eval networks-eval
(node-edges MIT)
(link/directed MIT UTAH)
(link/directed MIT HARV)
(neighbours? MIT HARV)
MIT
]}

@defproc[(link/undirected [from node?] [to node?]) (values node? node?)]{

@racket[link/undirected] creates an edge between @code{from} and
@code{to}; as it is an undirected link, it will be created both
ways. Accordingly, @racket[link/undirected] returns a pair of new
@racket[node]s. If the two nodes were already linked, nothing
happens. Like @racket[link/directed], it is non-destructive.

@examples[#:eval networks-eval
(node-edges MIT)
(node-edges UTAH)
(node-edges HARV)
(link/undirected MIT UTAH)
(link/undirected MIT HARV)
(neighbours? MIT HARV)
MIT
]}

@defproc[(get-node [network (listof (all/c node?))] [label symbol?]) (or/c node? void?)]{

@racket[get-node] finds the labeled @racket[node] in the network. It
returns void if no @racket[node] with the label exists in the network.

@examples[#:eval networks-eval
(get-node ARPA-NET 'mit)
(get-node ARPA-NET 'rpi)
]
}

@defproc[(get-node-map [network (listof (all/c node?))])
          (lambda node?)]{

@racket[get-node-map] returns a closure over @racket[get-node] and the
network. This is a convience for use in @racket[map] calls.

@examples[#:eval networks-eval
(set-map (node-edges MIT)
         (get-node-map ARPA-NET))
]}

@defproc[(followers [network (list-of (node?))] [node node?])
          (and/c integer? (or/c zero? positive?))]{

@racket[followers] returns a count of edges pointing @italic{into} the
node. If the network is undirected, this count will be the same as the
count returned from @racket[following].

@examples[#:eval networks-eval
(define simple-network (list node-1 node-2 node-3))
(followers simple-network node-3)
(followers simple-network node-1)
]}

@defproc[(following [network (list-of (node?))] [node node?])
         (and/c integer? (or/c zero? positive?))]{

@racket[following] returns a count of edges leading out of the
node. If the network is undirected, this count will be same as the
count returned from @racket[followers].

@examples[#:eval networks-eval
(following simple-network node-3)
(following simple-network node-1)
]}

@defproc[(sort-by-followers [network (list-of (node?))])
         (list-of 
          (pair? (and/c integer? (or/c zero? positive?)) 
                 node?))]{

@racket[sort-by-followers] returns a list of nodes sorted in
descending order by most followers. It is non-destructive, and list
returned

@examples[#:eval networks-eval
(define test-network
  (list
   (node 'node-1 '())
   (node 'node-2 '(node-1 node-3))
   (node 'node-3 '(node-1 node-2))
   (node 'node-4 '(node-3))
   (node 'node-6 '())
   (node 'node-5 '(node-1))))
(sort-by-followers test-network)
]

This can be useful in identifying key communications hubs, for
example:

@examples[#:eval networks-eval
(sort-by-followers ARPA-NET)
]

One might surmise by looking at the above rankings that UCLA and SRI
were core hubs in the ARPA network.}

@defproc[(directed-network? [network (list-of (node?))]) (boolean?)]{

@racket[directed-network?] returns true if the network is directed;
that is, every edge coming into a node is matched by a corresponding
edge outward.

@examples[#:eval networks-eval
(directed-network? ARPA-NET)
(directed-network? test-network)
]}

@subsubsection[#:tag "graph-search"]{search}
@defmodule[networks/graph/search]

The @code{search} package contains functions for searching through a network.

@defproc[(bfs [network (listof (node?))] [start symbol?] [end symbol?])
          (or/c
           (and/c (list-of node?) path?)
           (empty?))]{

@racket[bfs] performs a breadth-first search for a path between the
two nodes in the network. However, if no path can be found, an empty
list will be returned. It will perform a basic best-effort attempt at
building a simplified path from the returned path. This path
minimisation can be useful; prior to implementing it, the @racket[bfs]
in the examples below included extraneous edges, such as going from
@racket['sri] to @racket['ucsb] to @racket['ucla].

@examples[#:eval networks-eval
(define bfs-sri->harv (bfs ARPA-NET 'sri 'harv))
bfs-sri->harv
(path? bfs-sri->harv)
(simple-path? bfs-sri->harv)
]}

@defproc[(dfs [network (listof (node?))] [start symbol?] [end symbol?])
          (or/c
           (and/c (list-of node?) path?)
           (empty?))]{

@racket[dfs] performs a depth-first search for a path between the two
nodes in the network. However, if no path can be found, an empty list
will be returned. It will perform a basic best-effort attempt building
a simplified path from the returned path, as with @racket[bfs].

@examples[#:eval networks-eval
(define dfs-sri->harv (dfs ARPA-NET 'sri 'harv))
dfs-sri->harv
(path? dfs-sri->harv)
(simple-path? dfs-sri->harv)]}

@defproc[(connected? [network (list-of node?)]) (boolean?)]{

A network is said to be @italic{connected} if for every pair of nodes
in the network, there exists a path between them. An example is the
ARPA network: every system can get a message to any other system in
the network. This function is current implemented by running
@racket[bfs] on every pair of nodes in the network; it isn't a very
bright means to accomplish this, but it works. For larger networks, it
will certainly be less performant.

@examples[#:eval networks-eval
(connected? ARPA-NET)
(define disconnected-network
  (list
   (node 'node-1 '(node-2 node-3))
   (node 'node-2 '(node-1 node-3))
   (node 'node-3 '(node-1))
   (node 'node-4 '(node-5))
   (node 'node-5 '(node-4))))
(connected? disconnected-network)
]}

@defproc[(clean-path [path (list-of (node?))]) (list-of (node?))]{

@racket[clean-path] will attempt to find the shortest path that
goes from the first node in the path to the final node. It does so by
recursing through the list, skipping to the farthest neighbour in the
path it can find.

@examples[#:eval networks-eval
(let ([path (list
             (node 'sri (set 'utah 'stan 'ucla 'ucsb))
             (node 'ucsb (set 'ucla 'sri))
             (node 'ucla (set 'rand 'stan 'ucsb 'sri))
             (node 'rand (set 'bbn 'ucla 'sdc))
             (node 'bbn (set 'rand 'mit 'harv))
             (node 'harv (set 'bbn 'carn)))])
  (clean-path path))
]}