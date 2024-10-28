module Heaps

export MinHeap

# 0
# 1 2
# 3 4 5 6
# 7 8 9 10 11 12 13 14

struct MinHeap{T}
    elements::Vector{T}
end

function MinHeap{T}() where T
    return MinHeap{T}(T[])
end

firstindex(_::MinHeap) = 1
lastindex(mh::MinHeap) = length(mh.elements)

function Base.push!(mh::MinHeap, elem)
    push!(mh.elements, elem)
    ind = lastindex(mh)

    while ind != firstindex(mh)
        pind = parentindex(ind)

        # @info "Comparing $( mh.elements[pind] ) > $( mh.elements[ind] )"
        if mh.elements[ind] < mh.elements[pind]
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


Base.isempty(mh::MinHeap) = isempty(mh.elements)

function Base.pop!(mh::MinHeap)
    if length(mh.elements) == 1
        return pop!(mh.elements)
    end

    popped = mh.elements[firstindex(mh)]
    mh.elements[firstindex(mh)] = pop!(mh.elements)

    ind = firstindex(mh)
    while !isempty(mh) && ind <= lastindex(mh)
        lcind = leftchildindex(ind)
        rcind = rightchildindex(ind)

        haslc = lcind <= lastindex(mh)
        hasrc = rcind <= lastindex(mh)

        if haslc && hasrc
            if !(mh.elements[rcind] < mh.elements[lcind]) && mh.elements[lcind] < mh.elements[ind]
                mh.elements[lcind], mh.elements[ind] = mh.elements[ind], mh.elements[lcind]
                ind = lcind
            elseif mh.elements[rcind] < mh.elements[ind]
                mh.elements[rcind], mh.elements[ind] = mh.elements[ind], mh.elements[rcind]
                ind = rcind
            else 
                break
            end
        elseif haslc && mh.elements[lcind] < mh.elements[ind]
            mh.elements[lcind], mh.elements[ind] = mh.elements[ind], mh.elements[lcind]
            ind = lcind
        elseif hasrc && mh.elements[rcind] < mh.elements[ind]
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
