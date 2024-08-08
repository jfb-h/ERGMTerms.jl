function intersects(a, b)
    for x in a
        x in b && return true
    end
    return false
end

function dyads(g::AbstractGraph)
    itr = Iterators.product(vertices(g), vertices(g))
    itr = Iterators.filter(d -> first(d) != last(d), itr)
    itr
end

function dyads_mat(g::AbstractGraph)
    Iterators.product(vertices(g), vertices(g))
end
