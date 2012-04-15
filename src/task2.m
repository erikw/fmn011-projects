pr1.init_task(2)
format short

n = 8;
dia_elems = [-1 3 -1 0.5];
 % A is the sought sparse matrix. b=A[1...1]'
[A, b] = pr1.make_mat(n, dia_elems);
spy(A)
full(A)
b
