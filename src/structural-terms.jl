struct Reciprocity <: ERGMTerm end

function statistic(::Reciprocity, g::SimpleDiGraph)
    count(edges(g)) do e
        has_edge(g, dst(e), src(e))
    end
end

function changestat(::Reciprocity, g::SimpleDiGraph)
    a = adjacency_matrix(g)
    map(((u, v),) -> a[v, u], dyads(g))
end

