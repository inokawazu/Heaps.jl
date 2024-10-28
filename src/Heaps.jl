module Heaps

export heapify, priority_queue, minheap, maxheap, Heap

struct Heap{T}
    elements::Vector
    lt::Function
    by::Function
end

function minheap(T::Type)
    return Heap{T}(T[], <, identity)
end

function maxheap(T::Type)
    return Heap{T}(T[], >, identity)
end

function heapify(v, lt, by = identity)
    T = eltype(v)
    heap = Heap{T}(T[], lt, by)
    for elem in v
        push!(heap, elem)
    end
    return heap
end

# priority_lt(x, y) = last(x) > last(y)
# function priority_queue(T{K, V}) where {T, K,V}
# end

function priority_queue(Key::Type, Val::Type)
    return Heap{Pair{Key, Val}}(Pair{Key, Val}[], >, last)
end

ismaxheap(h::Heap) = h.lt == >
ispriorityqueue(h::Heap) = (h.lt == >) && (h.by == last)
isminheap(h::Heap) = h.lt == <

function Base.minimum(h::Heap)
    if !isminheap(h)
        ArgumentError("minimum is defined for min heaps only.")
    elseif isempty(h)
        ArgumentError("minimum is defined for non-empty sets only.")
    end

    return h[begin]
end

function Base.maximum(h::Heap)
    if !ismaxheap(h) && !ispriorityqueue(h)
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
    by = h.by

    while ind != firstindex(h)
        pind = parentindex(ind)

        if lt(by(h[ind]), by(h[pind]))
            swap!(h, pind, ind)
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

Base.copy(h::Heap{T}) where T = Heap{T}(copy(h.elements), h.lt, h.by)

function Base.pop!(h::Heap)
    if length(h.elements) == 1
        return pop!(h.elements)
    end

    popped = h.elements[firstindex(h)]
    h.elements[firstindex(h)] = pop!(h.elements)
    lt = h.lt
    by = h.by

    ind = firstindex(h)
    while !isempty(h) && ind <= lastindex(h)
        lcind = leftchildindex(ind)
        rcind = rightchildindex(ind)

        haslc = lcind <= lastindex(h)
        hasrc = rcind <= lastindex(h)

        if haslc && hasrc
            if !lt(by(h[rcind]), by(h[lcind])) && lt(by(h[lcind]), by(h[ind]))
                swap!(h, ind, lcind)
                ind = lcind
            elseif lt(by(h[rcind]), by(h[ind]))
                swap!(h, ind, rcind)
                ind = rcind
            else 
                break
            end
        elseif haslc && lt(by(h[lcind]), by(h[ind]))
            swap!(h, ind, lcind)
            ind = lcind
        elseif hasrc && lt(by(h[rcind]), by(h[ind]))
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
    bystr = h.by == identity ? "" : "by $(h.by)"
    if isminheap(h)
        println(io, "$(length(h)) MinHeap{$T} $bystr:")
    elseif ismaxheap(h)
        println(io, "$(length(h)) MaxHeap{$T} $bystr:")
    elseif ispriorityqueue(h)
        println(io, "$(length(h)) PriorityQueue{$T}:")
    else
        println(io, "$(length(h)) Heap{$T} with $(h.lt) $bystr:")
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
