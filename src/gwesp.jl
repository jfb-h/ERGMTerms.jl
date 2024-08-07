abstract type GroupTerm end

struct NoGroups <: GroupTerm end

struct SenderMatch{T} <: GroupTerm
    attr::T
end
struct ReceiverMatch{T} <: GroupTerm
    attr::T
end
struct StructuralFold{T} <: GroupTerm
    attr::T
end

struct GWESP{S<:GroupTerm,F} <: ERGMTerm
    gterm::S
    decay::Float64
    nbfun::F
end

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

statistic(a::GWESP, g::SimpleDiGraph) = stat!(a, zeros(Int, nv(g) - 1), g)

function stat!(a::GWESP, p::Vector{T}, g::SimpleDiGraph) where {T<:Integer}
    p = espcounts!(a, p, g)
    s = 0.0
    for i in 1:(nv(g)-2)
        s += p[i+1] * (1 - (1 - exp(-a.decay))^i)
    end
    exp(a.decay) * s
end

"""
    changestat(a, g)

Compute change statistics for `ERGMTerm` `a` for all dyads in graph `g`.
"""
function changestat end

function changestat(a::GWESP, g::SimpleDiGraph)
    p = zeros(Int, nv(g) - 1)
    s_obs = stat!(a, p, g)
    map(dyads(g)) do (i, j)
        compute_toggle!(p, a, s_obs, g, i, j)
    end
end

function compute_toggle!(p, a, s_obs, g, i, j)
    if has_edge(g, i, j)
        s1 = s_obs
        rem_edge!(g, i, j)
        s0 = stat!(a, p, g)
        add_edge!(g, i, j)
    else
        s0 = s_obs
        add_edge!(g, i, j)
        s1 = stat!(a, p, g)
        rem_edge!(g, i, j)
    end
    s1 - s0
end

_reverse(::typeof(inneighbors)) = outneighbors
_reverse(::typeof(outneighbors)) = inneighbors
_reverse(::typeof(all_neighbors)) = all_neighbors

function esp(a::GWESP{<:NoGroups}, g::SimpleDiGraph, i::Integer, j::Integer)
    ni = a.nbfun(g, i)
    nj = _reverse(a.nbfun)(g, j)
    s = 0
    for n in ni
        s += ifelse(n in nj, 1, 0)
    end
    s
end

function esp(a::GWESP{<:SenderMatch}, g::SimpleDiGraph, i::Integer, j::Integer)
    ni = a.nbfun(g, i)
    nj = _reverse(a.nbfun)(g, j)
    s = 0
    for n in ni
        pred = n in nj && intersects(a.gterm.attr[i], a.gterm.attr[n])
        s += ifelse(pred, 1, 0)
    end
    s
end

function esp(a::GWESP{<:ReceiverMatch}, g::SimpleDiGraph, i::Integer, j::Integer)
    ni = a.nbfun(g, i)
    nj = _reverse(a.nbfun)(g, j)
    s = 0
    for n in ni
        pred = n in nj && intersects(a.gterm.attr[j], a.gterm.attr[n])
        s += ifelse(pred, 1, 0)
    end
    s
end

function esp(a::GWESP{<:StructuralFold}, g::SimpleDiGraph, i::Integer, j::Integer)
    ni = a.nbfun(g, i)
    nj = _reverse(a.nbfun)(g, j)
    s = 0
    for n in ni
        pred = n in nj && intersects(a.gterm.attr[i], a.gterm.attr[n]) && intersects(a.gterm.attr[j], a.gterm.attr[n])
        s += ifelse(pred, 1, 0)
    end
    s
end

function espcounts!(a::GWESP{<:NoGroups}, out::Vector{T}, g::SimpleDiGraph) where {T<:Integer}
    fill!(out, zero(T))
    for e in edges(g)
        i = esp(a, g, src(e), dst(e))
        out[i+1] += 1
    end
    out
end

function espcounts!(a::GWESP{S}, out::Vector{T}, g::SimpleDiGraph) where {S<:GroupTerm,T<:Integer}
    fill!(out, zero(T))
    for e in edges(g)
        if intersects(a.gterm.attr[src(e)], a.gterm.attr[dst(e)])
            out[1] += 1
        else
            i = esp(a, g, src(e), dst(e))
            out[i+1] += 1
        end
    end
    out
end

