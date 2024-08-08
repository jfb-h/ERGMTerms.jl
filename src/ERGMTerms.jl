module ERGMTerms

using Reexport: @reexport
@reexport using Graphs

export statistic, changestats
export NodeMatch
export NodeCov, SenderCat, ReceiverCat
export Reciprocity
export GWESP, NoGroups, SenderMatch, ReceiverMatch, StructuralFold

abstract type ERGMTerm end

"""
    changestats(a, g)

Compute change statistics for `ERGMTerm` `a` for all dyads in graph `g`.
"""
function changestats end

"""
    statistic(a, g)

Compute statistic indicated by `ERGMTerm` `a` on `SimpleDiGraph` `g`.

# Examples

```julia
stat = GWESP(NoGroups(), 0.4, outneighbors)
statistic(stat, g)
```
"""
function statistic end

include("helpers.jl")
include("gwesp.jl")
include("structural-terms.jl")
include("nodeattribs.jl")

end
