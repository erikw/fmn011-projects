pr1.init_task(3)

n = 8;
dia_elems = [-1 3 -1 0.5];
maxtime = Inf;
[A, b] = pr1.make_mat(n, dia_elems);

% x is the solution to the system Ax=b found by naive Gaussian elimination.
% with back-substitution.
x = pr1.naive_gauss(A, b, maxtime)
