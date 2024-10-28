module Heaps

export heapify, minheap, maxheap, Heap

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

function heapify(v, by)
    T = eltype(v)
    heap = Heap{T}(T[], by)
    for elem in v
        push!(heap, elem)
    end
    return heap
end

ismaxheap(h::Heap) = h.lt == >
isminheap(h::Heap) = h.lt == <

function Base.minimum(h::Heap)
    if isminheap(h)
        ArgumentError("minimum is defined for min heaps only.")
    elseif isempty(h)
        ArgumentError("minimum is defined for non-empty sets only.")
    end

    return h[begin]
end

function Base.maximum(h::Heap)
    if ismaxheap(h)
        ArgumentError("maximum is defined for max heaps only.")
    elseif isempty(h)
        ArgumentError("maximum is defined for non-empty sets only.")
    end

    return h[begin]
end

Base.firstindex(h::Heap) = firstindex(h.elements)
Base.lastindex(h::Heap) = lastindex(h.elements)
Base.eachindex(h::Heap) = eachindex(h.elements)
Base.length(h::Heap) = length(h.elements)

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

Base.isempty(h::Heap) = isempty(h.elements)

function swap!(h::Heap, ind1, ind2)
    h[ind1], h[ind2] = h[ind2], h[ind1]
    return h
end

Base.copy(h::Heap{T}) where T = Heap{T}(copy(h.elements), h.lt)

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

function Base.collect(h::Heap{T}) where T
    h = copy(h)
    map(eachindex(h)) do _
        pop!(h)
    end
end

const MAX_HEAP_LEVEL_SHOW = 3

function Base.show(io::IO, h::Heap{T}) where T
    if isminheap(h)
        println(io, "$(length(h)) MinHeap{$T}:")
    elseif ismaxheap(h)
        println(io, "$(length(h)) MaxHeap{$T}:")
    else
        println(io, "$(length(h)) Heap{$T} with $(h.lt):")
    end

    level = 0
    queue = [(1, level)]
    elem_width = maximum(Iterators.take(eachindex(h), 2^MAX_HEAP_LEVEL_SHOW), init = 0) do ind
        textwidth(string(h[ind]))
    end

    elem_width = min(elem_width, displaysize(io)[2] ÷ 2^( MAX_HEAP_LEVEL_SHOW))

    while !isempty(queue) 
        ind, clevel = popfirst!(queue)
        

        if clevel > level
            level = clevel
            println(io)
            if level > MAX_HEAP_LEVEL_SHOW
                println("...")
                break
            end
        end
        if ind > lastindex(h)
            break
        end

        selem = rpad(h[ind], elem_width-1)
        if length(selem) + 1 > elem_width
            selem = chop(selem, tail = length(selem) + 1 - elem_width)
            selem = chop(selem, tail = 2)
            selem *= ".."
        end
        print(io, "$selem ")

        lcind = leftchildindex(ind)
        rcind = rightchildindex(ind)
        if lcind <= length(h.elements) && lcind < 2^(MAX_HEAP_LEVEL_SHOW+1) + 1
            push!(queue, (lcind, clevel + 1))
            if rcind <= length(h.elements) && rcind < 2^(MAX_HEAP_LEVEL_SHOW+1) + 1 1
                push!(queue, (rcind, clevel + 1))
            end
        end
    end
end

end # module Heap
