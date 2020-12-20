using starlight
using Test

@testset "ray tracer challenge" begin

    @testset "ch 1 - tuples, Point4s, and Vector4s" begin

        #=
            test cases for tuples, points, and vectors turned into
            smoke tests of julia's native data types and standard library.
            not super meaningful, but definitely helps me learn julia and
            get an idea of what to expect later.
        =#

        vals = [4.3, -4.2, 3.1, 1.0]

        a = copy(vals)
        @test x(a) == 4.3
        @test y(a) == -4.2
        @test z(a) == 3.1
        @test w(a) == 1.0
        @test a == Point4(vals)
        @test a != Vector4(vals)

        w!(a, 0.0)
        @test x(a) == 4.3
        @test y(a) == -4.2
        @test z(a) == 3.1
        @test w(a) == 0.0
        @test a != Point4(vals)
        @test a == Vector4(vals)

        @test Point4([4, -4, 3]) == [4, -4, 3, 1]
        @test Vector4([4, -4, 3]) == [4, -4, 3, 0]
        @test [3, -2, 5, 1] + [-2, 3, 1, 0] == [1, 1, 6, 1]
        @test Point4([3, 2, 1]) - Point4([5, 6, 7]) == Vector4([-2, -4, -6])
        @test Point4([3, 2, 1]) - Vector4([5, 6, 7]) == Point4([-2, -4, -6])
        @test Vector4([3, 2, 1]) - Vector4([5, 6, 7]) == Vector4([-2, -4, -6])
        @test Vector4([0, 0, 0]) - Vector4([1, -2, 3]) == Vector4([-1, 2, -3])
        @test -[1, -2, 3, -4] == [-1, 2, -3, 4]
        @test 3.5 * [1, -2, 3, -4] == [3.5, -7, 10.5, -14]
        @test 0.5 * [1, -2, 3, -4] == [0.5, -1, 1.5, -2]
        @test [1, -2, 3, -4] / 2 == [0.5, -1, 1.5, -2]

        @test norm(Vector4([1, 0, 0])) == 1
        @test norm(Vector4([0, 1, 0])) == 1
        @test norm(Vector4([0, 0, 1])) == 1
        @test norm(Vector4([1, 2, 3])) == √14 # i love julia
        @test norm(Vector4([-1, -2, -3])) == √14

        @test normalize(Vector4([4, 0, 0])) == Vector4([1, 0, 0])
        @test normalize(Vector4([1, 2, 3])) == Vector4([1/√14, 2/√14, 3/√14]) # i really love julia
        @test norm(normalize(Vector4([1, 2, 3]))) == 1

        # i really really really love julia
        @test Vector4([1, 2, 3]) ⋅ Vector4([2, 3, 4]) == 20
        @test Vector4([1, 2, 3] × [2, 3, 4]) == Vector4([-1, 2, -1])
        @test Vector4([2, 3, 4] × [1, 2, 3]) == Vector4([1, -2, 1])
    end

    @testset "ch 2 - drawing on a canvas" begin

        #=
            color definitions from julia's Colors package, color arithmetic
            from ColorVectorSpace. inclusion of Images and a couple of extra
            dependencies allows displaying colors in notebooks as well as
            Juno's Plots pane. so now i'm also learning and smoke-testing
            julia's package ecosystem.
        =#

        c = RGB(-0.5, 0.4, 1.7)
        @test red(c) == -0.5
        @test green(c) == 0.4
        @test blue(c) == 1.7

        c = RGB(0.9, 0.6, 0.75) + RGB(0.7, 0.1, 0.25)
        @test red(c) == 1.6
        @test green(c) == 0.7
        @test blue(c) == 1.0

        c = RGB(0.9, 0.6, 0.75) - RGB(0.7, 0.1, 0.25)
        @test red(c) ≈ 0.2 # never really know where numerical instability will strike
        @test green(c) == 0.5
        @test blue(c) == 0.5

        c = 2 * RGB(0.2, 0.3, 0.4)
        @test red(c) == 0.4
        @test green(c) == 0.6
        @test blue(c) == 0.8

        c = hadamard(RGB(1, 0.2, 0.4), RGB(0.9, 1, 0.1))
        @test red(c) == 0.9
        @test green(c) == 0.2
        @test blue(c) ≈ 0.04 # again with the instability, and again it's easier to handle in julia than python

        c = Canvas(10, 20)
        @test width(c) == 10 # Images.width
        @test height(c) == 20 # Images.height
        @test all(col == colorant"black" for col in pixels(c))

        pixel!(c, 2, 3, colorant"red")
        @test pixel(c, 2, 3) == colorant"red"
    end

    @testset "ch 3 - matrices" begin
        M = [
            1 2 3 4
            5.5 6.5 7.5 8.5
            9 10 11 12
            13.5 14.5 15.5 16.5
        ]
        @test M[1,1] == 1
        @test M[1,4] == 4
        @test M[2,1] == 5.5
        @test M[2,3] == 7.5
        @test M[3,3] == 11
        @test M[4,1] == 13.5
        @test M[4,3] == 15.5

        M = [
            -3 5
            1 -2
        ]
        @test M[1,1] == -3
        @test M[1,2] == 5
        @test M[2,1] == 1
        @test M[2,2] == -2

        M = [
            -3 5 0
            1 -2 -7
            0 1 1
        ]
        @test M[1,1] == -3
        @test M[2,2] == -2
        @test M[3,3] == 1

        A = [
            1 2 3 4
            5 6 7 8
            9 8 7 6
            5 4 3 2
        ]
        B = [
            1 2 3 4
            5 6 7 8
            9 8 7 6
            5 4 3 2
        ]
        @test A == B

        A = [
            1 2 3 4
            5 6 7 8
            9 8 7 6
            5 4 3 2
        ]
        B = [
            2 3 4 5
            6 7 8 9
            8 7 6 5
            4 3 2 1
        ]
        @test A != B

        A = [
            1 2 3 4
            5 6 7 8
            9 8 7 6
            5 4 3 2
        ]
        B = [
            -2 1 2 3
            3 2 1 -1
            4 3 6 5
            1 2 7 8
        ]
        @test A * B == [
            20 22 50 48
            44 54 114 108
            40 58 110 102
            16 26 46 42
        ]

        A = [
            1 2 3 4
            2 4 4 2
            8 6 4 1
            0 0 0 1
        ]
        b = [1 2 3 1]
        @test A * b' == [18 24 33 1]'

        A = [
            0 1 2 4
            1 2 4 8
            2 4 8 16
            4 8 16 32
        ]
        @test A*I == A
        @test I*A == A

        a = [1 2 3 4]'
        @test a*I == a
        @test I*a == a

        A = [
            0 9 3 0
            9 8 0 8
            1 8 5 3
            0 0 5 8
        ]
        @test A' == [
            0 9 1 0
            9 8 8 0
            3 0 5 5
            0 8 3 8
        ]
        @test I' == I

        A = [
            1 5
            -3 2
        ]
        @test det(A) == 17

        A = [
            1 5 0
            -3 2 7
            0 6 -3
        ]
        @test submatrix(A, 1, 3) == [-3 2; 0 6]

        A = [
            -6 1 1 6
            -8 5 8 6
            -1 0 8 2
            -7 1 -1 1
        ]
        @test submatrix(A, 3, 2) == [
            -6 1 6
            -8 8 6
            -7 -1 1
        ]

        A = [
            3 5 0
            2 -1 -7
            6 -1 5
        ]
        B = submatrix(A, 2, 1)
        @test det(B) == 25
        @test minor(A, 2, 1) == 25

        A = [
            3 5 0
            2 -1 -7
            6 -1 5
        ]
        @test minor(A, 1, 1) == -12
        @test cofactor(A, 1, 1) == -12
        @test minor(A, 2, 1) == 25
        @test cofactor(A, 2, 1) == -25

        A = [
            1 2 6
            -5 8 -4
            2 6 4
        ]
        @test cofactor(A, 1, 1) == 56
        @test cofactor(A, 1, 2) == 12
        @test cofactor(A, 1, 3) == -46
        @test det(A) ≈ -196

        A = [
            -2 -8 3 5
            -3 1 7 3
            1 2 -9 6
            -6 7 7 -9
        ]
        @test cofactor(A, 1, 1) == 690
        @test cofactor(A, 1, 2) == 447
        @test cofactor(A, 1, 3) ≈ 210
        @test cofactor(A, 1, 4) ≈ 51
        @test det(A) ≈ -4071

        A = [
            6 4 4 4
            5 5 7 6
            4 -9 3 -7
            9 1 7 -6
        ]
        @test det(A) ≈ -2120
        @test invertible(A)

        A = [
            -4 2 -2 -3
            9 6 2 6
            0 -5 1 -5
            0 0 0 0
        ]
        @test det(A) == 0
        @test !invertible(A)

        A = [
            -5 2 6 -8
            1 -5 1 8
            7 7 -6 -7
            1 -3 7 4
        ]
        B = inv(A)
        @test det(A) == 532
        @test cofactor(A, 3, 4) ≈ -160
        @test B[4,3] ≈ -160 / 532
        @test cofactor(A, 4, 3) ≈ 105
        @test B[3,4] ≈ 105 / 532
        @test round.(B, digits=5) == [
            0.21805 0.45113 0.24060 -0.04511
            -0.80827 -1.45677 -0.44361 0.52068
            -0.07895 -0.22368 -0.05263 0.19737
            -0.52256 -0.81391 -0.30075 0.30639
        ]

        A = [
            8 -5 9 2
            7 5 6 1
            -6 0 9 6
            -3 0 -9 -4
        ]
        @test round.(inv(A), digits=5) == [
            -0.15385 -0.15385 -0.28205 -0.53846
            -0.07692 0.12308 0.02564 0.03077
            0.35897 0.35897 0.43590 0.92308
            -0.69231 -0.69231 -0.76923 -1.92308
        ]

        A = [
            9 3 0 9
            -5 -2 -6 -3
            -4 9 6 4
            -7 6 6 2
        ]
        @test round.(inv(A), digits=5) == [
            -0.04074 -0.07778 0.14444 -0.22222
            -0.07778 0.03333 0.36667 -0.33333
            -0.02901 -0.14630 -0.10926 0.12963
            0.17778 0.06667 -0.26667 0.33333
        ]

        A = [
            3 -9 7 3
            3 -8 2 -9
            -4 4 4 1
            -6 5 -1 1
        ]
        B = [
            8 2 2 2
            3 -1 7 0
            7 0 5 4
            6 -2 0 5
        ]
        C = A * B
        @test C * inv(B) ≈ A
    end

    @testset "ch 4 - matrix transformations" begin

    end

    @testset "ch 5 - ray-sphere intersections" begin

    end

    @testset "ch 6 - light and shading" begin

    end

    @testset "ch 7 - making a scene" begin

    end

    @testset "ch 8 - shadows" begin

    end

    @testset "ch 9 - planes" begin

    end

    @testset "ch 10 - patterns" begin

    end

    @testset "ch 11 - reflection and refraction" begin

    end

    @testset "ch 12 - cubes" begin

    end

    @testset "ch 13 - cylinders" begin

    end

    @testset "ch 14 - groups" begin

    end

    @testset "ch 15 - triangles" begin

    end

    @testset "ch 16 - constructive solid geometry" begin

    end

end
