pr1.init_task(13)

nbr_systems = 8;
solve_times = 100;
maxit = Inf;
maxtime = Inf;
n = 2^7; % From task 12.

% GE
means = pr1.multi_solve_gauss(nbr_systems, n, solve_times, maxtime);
mean_ge = mean(means);
means_str =  sprintf('%.10fs\n', means);
fprintf(1, 'Solving  %i perturbed systems with GE with 2^%i unknowns %i times each gave the following mean solve times with a total mean of %.10fs:\n%s\n', nbr_systems, log2(n), solve_times, mean_ge, means_str);

% SOR
means = pr1.multi_solve_sor(nbr_systems, n, solve_times, maxit, maxtime);
mean_sor = mean(means);
means_str =  sprintf('%.10fs\n', means);
fprintf(1, 'Solving  %i perturbed systems with SOR with 2^%i unknowns %i times each gave the following mean solve times with a total mean of %.10fs:\n%s', nbr_systems, log2(n), solve_times, mean_sor, means_str);