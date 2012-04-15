pr1.init_task(11)

n = 8;
solve_times = 100;
maxit = Inf;
maxtime = Inf;

[original_mean, perturbed_mean] = pr1.duosolve_sor(n, solve_times, maxit, maxtime);
percent = (perturbed_mean/original_mean) * 100;

fprintf(1,'With n=%i and %i time measurements, the mean time for solving the original system (Ax=b) with SOR (in Fixed-Point Iteration mode) is %fs and for the perturbed system (Ap*x=bp) %fs (i.e. %.2f%% of the original mean time).\n', n, solve_times, original_mean, perturbed_mean, percent);
