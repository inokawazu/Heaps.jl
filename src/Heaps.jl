module Heaps

export heapify, minheap, maxheap, Heap

# 0
# 1 2
# 3 4 5 6
# 7 8 9 10 11 12 13 14

struct Heap{T}
    elements::Vector
    lt::Function
end

function minheap(T::Type)
    return Heap{T}(T[], <)
end

function maxheap(T::Type)
    return Heap{T}(T[], >)
end

function heapify(v, by = <)
    T = eltype(v)
    heap = Heap{T}(T[], by)
    for elem in v
        push!(heap, elem)
    end
    return heap
end

firstindex(_::Heap) = 1
lastindex(h::Heap) = length(h.elements)

Base.getindex(h::Heap, i) = h.elements[i]
Base.setindex!(h::Heap, X, i) = h.elements[i] = X

function Base.push!(h::Heap, elem)
    push!(h.elements, elem)
    ind = lastindex(h)
    lt = h.lt

    while ind != firstindex(h)
        pind = parentindex(ind)

        if lt(h[ind], h[pind])
            h[pind], h[ind] = h[ind], h[pind]
            ind = pind
        else
            break
        end
    end

    return h
end

function Base.push!(h::Heap, elem, rest...)
    push!(push!(h, elem), rest...)
end

# 1
# 2 3
# 4 5
#
# _
# 2 3
# 4 5
#
# 5
# 2 3
# 4
#
# 2
# 4 3
# 5

# 1
# 3 2
# 4 5
#
# 5
# 3 2
# 4

Base.isempty(h::Heap) = isempty(h.elements)

function swap!(h::Heap, ind1, ind2)
    h[ind1], h[ind2] = h[ind2], h[ind1]
    return h
end

function Base.pop!(h::Heap)
    if length(h.elements) == 1
        return pop!(h.elements)
    end

    popped = h.elements[firstindex(h)]
    h.elements[firstindex(h)] = pop!(h.elements)
    lt = h.lt

    ind = firstindex(h)
    while !isempty(h) && ind <= lastindex(h)
        lcind = leftchildindex(ind)
        rcind = rightchildindex(ind)

        haslc = lcind <= lastindex(h)
        hasrc = rcind <= lastindex(h)

        if haslc && hasrc
            if !lt(h[rcind], h[lcind]) && lt(h[lcind], h[ind])
                swap!(h, ind, lcind)
                ind = lcind
            elseif lt(h[rcind], h[ind])
                swap!(h, ind, rcind)
                ind = rcind
            else 
                break
            end
        elseif haslc && lt(h[lcind], h[ind])
            swap!(h, ind, lcind)
            ind = lcind
        elseif hasrc && lt(h[rcind], h[ind])
            swap!(h, ind, rcind)
            ind = rcind
        else
            break
        end

    end

    return popped
end

parentindex(ind) = ( ind - 2 ) ÷ 2 + 1
leftchildindex(ind) = ( ind - 1  ) * 2 + 2
rightchildindex(ind) = ( ind - 1  ) * 2 + 3

end # module Heap
