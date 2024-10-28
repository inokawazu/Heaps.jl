module Heaps

export heapify, minheap, Heap

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

function heapify(v, by = <)
    T = eltype(v)
    heap = Heap{T}(T[], by)
    for elem in v
        push!(heap, elem)
    end
    return heap
end

firstindex(_::Heap) = 1
lastindex(mh::Heap) = length(mh.elements)

function Base.push!(mh::Heap, elem)
    push!(mh.elements, elem)
    ind = lastindex(mh)
    lt = mh.lt

    while ind != firstindex(mh)
        pind = parentindex(ind)

        # @info "Comparing $( mh.elements[pind] ) > $( mh.elements[ind] )"
        if lt(mh.elements[ind], mh.elements[pind])
            mh.elements[pind], mh.elements[ind] = mh.elements[ind], mh.elements[pind]
            ind = pind
        else
            break
        end
    end

    return mh
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


Base.isempty(mh::Heap) = isempty(mh.elements)

function Base.pop!(mh::Heap)
    if length(mh.elements) == 1
        return pop!(mh.elements)
    end

    popped = mh.elements[firstindex(mh)]
    mh.elements[firstindex(mh)] = pop!(mh.elements)
    lt = mh.lt

    ind = firstindex(mh)
    while !isempty(mh) && ind <= lastindex(mh)
        lcind = leftchildindex(ind)
        rcind = rightchildindex(ind)

        haslc = lcind <= lastindex(mh)
        hasrc = rcind <= lastindex(mh)

        if haslc && hasrc
            if !lt(mh.elements[rcind], mh.elements[lcind]) && lt(mh.elements[lcind], mh.elements[ind])
                mh.elements[lcind], mh.elements[ind] = mh.elements[ind], mh.elements[lcind]
                ind = lcind
            elseif lt(mh.elements[rcind], mh.elements[ind])
                mh.elements[rcind], mh.elements[ind] = mh.elements[ind], mh.elements[rcind]
                ind = rcind
            else 
                break
            end
        elseif haslc && lt(mh.elements[lcind], mh.elements[ind])
            mh.elements[lcind], mh.elements[ind] = mh.elements[ind], mh.elements[lcind]
            ind = lcind
        elseif hasrc && lt(mh.elements[rcind], mh.elements[ind])
            mh.elements[rcind], mh.elements[ind] = mh.elements[ind], mh.elements[rcind]
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
