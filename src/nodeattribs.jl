#TODO: implement diff nodematch
struct NodeMatch{T} <: ERGMTerm
    attr::T
end

function statistic(a::NodeMatch, g::AbstractGraph)
    count(edges(g)) do e
        intersects(a.attr[src(e)], a.attr[dst(e)])
    end
end

function changestats(a::NodeMatch, g::AbstractGraph)
    map(((u, v),) -> Int(intersects(a.attr[u], a.attr[v])), dyads(g))
end

abstract type CovSpec end

struct NodeCov{S<:CovSpec} <: ERGMTerm
    spec::S
end

struct SenderNum{T<:Real} <: CovSpec
    attr::Vector{T}
end
struct ReceiverNum{T<:Real} <: CovSpec
    attr::Vector{T}
end
struct SenderCat{T<:Integer} <: CovSpec
    attr::Vector{T}
end
struct ReceiverCat{T<:Integer} <: CovSpec
    attr::Vector{T}
end
function _stat_nodecov_cat(a, g, fun)
    vals = sort!(unique(a.spec.attr))
    out = zeros(Int, length(vals))
    for e in edges(g)
        out[a.spec.attr[fun(e)]] += 1
    end
    out
end

statistic(a::NodeCov{<:SenderCat}, g::SimpleDiGraph) = _stat_nodecov_cat(a, g, src)
statistic(a::NodeCov{<:ReceiverCat}, g::SimpleDiGraph) = _stat_nodecov_cat(a, g, dst)

function _cstat_nodecov_cat(a, g, fun)
    vals = sort!(unique(a.spec.attr))
    out = [zeros(Int, nv(g) * (nv(g) - 1)) for _ in 1:length(vals)]
    for (i, d) in enumerate(dyads(g))
        out[a.spec.attr[fun(d)]][i] = 1
    end
    out
end

changestats(a::NodeCov{<:SenderCat}, g::SimpleDiGraph) = _cstat_nodecov_cat(a, g, first)
changestats(a::NodeCov{<:ReceiverCat}, g::SimpleDiGraph) = _cstat_nodecov_cat(a, g, last)

