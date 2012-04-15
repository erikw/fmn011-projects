pr1.init_task(9);

n = 8;
dia_elems = [-1 3 -1 0.5];
 % A and b are perturbed from the original system. x is the solution to Ax=b.
[A, b, x] = pr1.make_perturbed_mat(n, dia_elems);
full(A)
x
b