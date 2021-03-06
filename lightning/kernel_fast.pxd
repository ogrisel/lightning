# Author: Mathieu Blondel
# License: BSD

from libcpp.list cimport list
from libcpp.map cimport map

cimport numpy as np

cdef class Kernel:

    cpdef double compute(self,
                         np.ndarray[double, ndim=2, mode='c'] X,
                         int i,
                         np.ndarray[double, ndim=2, mode='c'] Y,
                         int j)

    cpdef double compute_self(self,
                              np.ndarray[double, ndim=2, mode='c'] X,
                              int i)

cdef class LinearKernel(Kernel):

    cpdef double compute(self,
                         np.ndarray[double, ndim=2, mode='c'] X,
                         int i,
                         np.ndarray[double, ndim=2, mode='c'] Y,
                         int j)


cdef class PolynomialKernel(Kernel):
    cdef int degree
    cdef double coef0, gamma

    cpdef double compute(self,
                         np.ndarray[double, ndim=2, mode='c'] X,
                         int i,
                         np.ndarray[double, ndim=2, mode='c'] Y,
                         int j)


cdef class RbfKernel(Kernel):
    cdef double gamma

    cpdef double compute(self,
                         np.ndarray[double, ndim=2, mode='c'] X,
                         int i,
                         np.ndarray[double, ndim=2, mode='c'] Y,
                         int j)

    cpdef double compute_self(self,
                              np.ndarray[double, ndim=2, mode='c'] X,
                              int i)


cdef class PrecomputedKernel(Kernel):

    cpdef double compute(self,
                         np.ndarray[double, ndim=2, mode='c'] X,
                         int i,
                         np.ndarray[double, ndim=2, mode='c'] Y,
                         int j)


cdef class KernelCache(Kernel):
    cdef Kernel kernel
    cdef int n_samples
    cdef list[int]* support_set
    cdef list[int].iterator* support_it
    cdef int* support_vector
    cdef map[int, double*]* columns
    cdef int* n_computed
    cdef long capacity
    cdef int verbose
    cdef long size

    cdef _create_column(self, int i)
    cdef _clear_columns(self, int n)

    cpdef double compute(self,
                         np.ndarray[double, ndim=2, mode='c'] X,
                         int i,
                         np.ndarray[double, ndim=2, mode='c'] Y,
                         int j)

    cpdef double compute_self(self,
                              np.ndarray[double, ndim=2, mode='c'] X,
                              int i)

    cpdef compute_diag(self,
                       np.ndarray[double, ndim=2, mode='c'] X,
                       np.ndarray[double, ndim=1, mode='c'] out)


    cpdef compute_column(self,
                         np.ndarray[double, ndim=2, mode='c'] X,
                         np.ndarray[double, ndim=2, mode='c'] Y,
                         int j,
                         np.ndarray[double, ndim=1, mode='c'] out)

    cpdef compute_column_sv(self,
                            np.ndarray[double, ndim=2, mode='c'] X,
                            np.ndarray[double, ndim=2, mode='c'] Y,
                            int j,
                            np.ndarray[double, ndim=1, mode='c'] out)

    cpdef remove_column(self, int i)
    cpdef add_sv(self, int i)
    cpdef remove_sv(self, int i)
    cpdef int n_sv(self)
    cpdef get_size(self)
