# ERGMTerms

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jfb-h.github.io/ERGMTerms.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jfb-h.github.io/ERGMTerms.jl/dev/)
[![Build Status](https://github.com/jfb-h/ERGMTerms.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jfb-h/ERGMTerms.jl/actions/workflows/CI.yml?query=branch%3Amain)

ATTENTION: This package is work in progress and might change frequently! Things are possibly wrong and likely not as performant as they could and should be.

## Example

The workhorse functions of this package are `statistic(stat, g)` and `changestats(stat, g)`, both of which take a ERGM statistic specification `stat` and a graph `g`, as represented by the `Graphs.jl` library (which is reexported).

here is an example for a random graph:

```julia-repl
julia> using ERGMTerms

julia> g = erdos_renyi(50, 100; is_directed=true)
{50, 100} directed simple Int64 graph

julia> stat = Reciprocity()
Reciprocity()

julia> statistic(stat, g)
6

julia> changestats(stat, g)
2450-element Vector{Int64}:
 0
 0
 ⋮
 0
 0
```
