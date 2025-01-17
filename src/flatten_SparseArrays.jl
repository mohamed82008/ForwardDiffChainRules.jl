#
# Copyright (c) 2022 The contributors
# Licensed under the MIT license. See LICENSE file in the project root for details.
#

# Adapted from NonconvexCore.jl with the following license.
#=
MIT License

Copyright (c) 2021 Mohamed Tarek <mohamed82008@gmail.com> and contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=#

# Adapted from ParameterHandling.jl with the following license.
#=
Copyright (c) 2020 Invenia Technical Computing Corporation
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=#

# Zygote can return a sparse vector co-tangent
# even if the input is a vector. This is causing
# issues in the rrule definition of Unflatten
flatten(x::SparseVector) = flatten(Array(x))

function flatten(x::SparseMatrixCSC)
    x_vec, from_vec = flatten(x.nzval)
    Array_from_vec(x_vec) = SparseMatrixCSC(x.m, x.n, x.colptr, x.rowval, from_vec(x_vec))
    return identity.(x_vec), Array_from_vec
end

# Zygote can return a sparse vector co-tangent
# even if the input is a vector. This is causing
# issues in the rrule definition of Unflatten
zygote_flatten(x1::SparseVector, x2::SparseVector) = zygote_flatten(Array(x1), Array(x2))

function zygote_flatten(x1::SparseMatrixCSC, x2::SparseMatrixCSC)
    x_vec, from_vec = zygote_flatten(x1.nzval, x2.nzval)
    Array_from_vec(x_vec) = SparseMatrixCSC(x.m, x.n, x.colptr, x.rowval, from_vec(x_vec))
    return identity.(x_vec), Array_from_vec
end
