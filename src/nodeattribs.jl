#TODO: implement diff nodematch
struct NodeMatch{T} <: ERGMTerm
    attr::T
end

function statistic(a::NodeMatch, g::AbstractGraph)
    count(edges(g)) do e
        intersects(a.attr[src(e)], a.attr[dst(e)])
    end
end

function changestat(a::NodeMatch, g::AbstractGraph)
    map(((u, v),) -> Int(intersects(a.attr[u], a.attr[v])), dyads(g))
end
