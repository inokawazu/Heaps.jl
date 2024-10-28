using Test
using Heaps

# 1
# 2 3
# 4 5 6 7
# 8 9 10 11 12 13 14 15
@testset "Parent Index Tests" begin
    @test Heaps.parentindex(2) == 1
    @test Heaps.parentindex(3) == 1
    @test Heaps.parentindex(4) == 2
    @test Heaps.parentindex(5) == 2
    @test Heaps.parentindex(6) == 3
end

@testset "Left Child Index Tests" begin
    @test Heaps.leftchildindex(1) == 2
    @test Heaps.leftchildindex(2) == 4
    @test Heaps.leftchildindex(3) == 6
    @test Heaps.leftchildindex(4) == 8
    @test Heaps.leftchildindex(5) == 10
end

@testset "Right Child Index Tests" begin
    @test Heaps.rightchildindex(1) == 3
    @test Heaps.rightchildindex(2) == 5
    @test Heaps.rightchildindex(3) == 7
    @test Heaps.rightchildindex(4) == 9
    @test Heaps.rightchildindex(5) == 11
end

function minheap_push_pop_test(elems)
    heap = minheap(eltype(elems))

    for elem in elems
        push!(heap, elem)
    end

    for i in sort(elems)
        @test pop!(heap) == i
    end
end

@testset "Push Pop Tests minheap" begin
    @testset "1 through 10" minheap_push_pop_test([10, 1, 3, 9, 2, 8, 6, 4, 7, 5])
    @testset "1 through 100" minheap_push_pop_test([65, 84, 23, 69, 34, 17, 30, 76, 11, 89, 42, 47, 50, 16, 6, 99, 13, 19, 91, 3, 18, 71, 93, 77, 90, 15, 25, 60, 61, 10, 70, 38, 31, 4, 94, 22, 92, 28, 45, 95, 40, 96, 35, 58, 5, 62, 21, 68, 32, 27, 98, 67, 81, 80, 73, 51, 9, 78, 39, 46, 2, 1, 43, 54, 52, 72, 97, 83, 44, 29, 41, 75, 74, 14, 88, 87, 37, 86, 48, 79, 24, 49, 59, 85, 57, 66, 7, 64, 63, 56, 100, 82, 8, 20, 33, 36, 53, 26, 12, 55])
    @testset "alphabet" minheap_push_pop_test(['o', 'g', 'k', 's', 'p', 'z', 'i', 'q', 'x', 'r', 'd', 'b', 'a', 'l', 'f', 'j', 'm', 'u', 'c', 'h', 'n', 'v', 'y', 'w', 'e', 't'])

    @testset "Splat Test" begin heap = minheap(Int)
        elems = [5, 2, 4, 3, 1]
        push!(heap, elems...)

        for i in sort(elems)
            @test pop!(heap) == i
        end
    end
end

@testset "Minheap Empty" begin
    heap = minheap(Int64)
    @test isempty(heap)
    push!(heap, 1)
    @test !isempty(heap)
end

function maxheap_push_pop_test(elems)
    heap = maxheap(eltype(elems))

    for elem in elems
        push!(heap, elem)
    end

    for i in sort(elems, rev=true)
        @test pop!(heap) == i
    end
end

@testset "Push Pop Tests maxheap" begin
    @testset "1 through 10" maxheap_push_pop_test([10, 1, 3, 9, 2, 8, 6, 4, 7, 5])
    @testset "1 through 100" maxheap_push_pop_test([65, 84, 23, 69, 34, 17, 30, 76, 11, 89, 42, 47, 50, 16, 6, 99, 13, 19, 91, 3, 18, 71, 93, 77, 90, 15, 25, 60, 61, 10, 70, 38, 31, 4, 94, 22, 92, 28, 45, 95, 40, 96, 35, 58, 5, 62, 21, 68, 32, 27, 98, 67, 81, 80, 73, 51, 9, 78, 39, 46, 2, 1, 43, 54, 52, 72, 97, 83, 44, 29, 41, 75, 74, 14, 88, 87, 37, 86, 48, 79, 24, 49, 59, 85, 57, 66, 7, 64, 63, 56, 100, 82, 8, 20, 33, 36, 53, 26, 12, 55])
    @testset "alphabet" maxheap_push_pop_test(['o', 'g', 'k', 's', 'p', 'z', 'i', 'q', 'x', 'r', 'd', 'b', 'a', 'l', 'f', 'j', 'm', 'u', 'c', 'h', 'n', 'v', 'y', 'w', 'e', 't'])
end
