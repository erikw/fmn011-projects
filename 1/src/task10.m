pr1.init_task(10)

n = 8;
solve_times = 100;
maxtime = Inf;

[original_mean, perturbed_mean] = pr1.duosolve_gauss(n, solve_times, maxtime);
percent = (perturbed_mean/original_mean) * 100;

fprintf(1,'With n=%i and %i time measurements, the mean time for solving the original system (Ax=b) with naive Gaussian elimination is %fs and for the perturbed system (Ap*x=bp) %fs (i.e. %.2f%% of the original mean time).\n', n, solve_times, original_mean, perturbed_mean, percent);
