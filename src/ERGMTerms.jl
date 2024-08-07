module ERGMTerms

using Reexport: @reexport
@reexport using Graphs

export statistic, changestat
export NodeMatch
export Reciprocity
export GWESP, NoGroups, SenderMatch, ReceiverMatch, StructuralFold

abstract type ERGMTerm end

include("helpers.jl")
include("gwesp.jl")
include("structural-terms.jl")
include("nodeattribs.jl")

end
