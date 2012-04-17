pr1.init_task(12)

solve_times = 100;
maxit = Inf;
maxtime = 5*60*60; % In seconds. This is for each test i.e. the scripts total max time is 2*maxtime.

% Find largest k for Gauss.
n_ge = 8;
pr1.time_out(maxtime);
can_solve = true;
while can_solve
	try
		[orig_mean, pert_mean] = pr1.duosolve_gauss(n_ge, solve_times);
		percent = (pert_mean/orig_mean) * 100;
		fprintf(1, 'Solved duo Gauss for k=%i, orig_mean=%.5fs and pert_mean=%.5fs (i.e. %.2f%% of the original mean time).\n', log2(n_ge), orig_mean, pert_mean, percent);
		n_ge = bitshift(n_ge, 1);
	catch ex
		can_solve = false;
		fprintf(2, 'Can''t solve more. Time out reached. \n');
	end
end
fprintf(1, 'In %i seconds both the original and perturbed system could be solved with Gaussian elimination with a system 2^%i unknowns. For the largest system solved; orig_mean=%.5fs and pert_mean=%.5fs (i.e. %.2f%% of the original mean time).\n\n', maxtime, (log2(n_ge)-1), orig_mean, pert_mean, percent);

% Find largest k for SOR.
n_sor = 8;
pr1.time_out(maxtime);
can_solve = true;
while can_solve
	try
		[orig_mean, pert_mean] = pr1.duosolve_sor(n_sor, solve_times, maxit);
		percent = (pert_mean/orig_mean) * 100;
		fprintf(1, 'Solved duo SOR for k=%i, orig_mean=%.5fs and pert_mean=%.5fs (i.e. %.2f%% of the original mean time).\n', log2(n_sor), orig_mean, pert_mean, percent);
		n_sor = bitshift(n_sor, 1);
	catch ex
		can_solve = false;
        fprintf(2, 'Can''t solve more. Time out reached. \n');
	end
end
fprintf(1, 'In %i seconds both the original and perturbed system could be solved with SOR with a system 2^%i unknowns. For the largest system solved; orig_mean=%.5fs and pert_mean=%.5fs (i.e. %.2f%% of the original mean time).\n', maxtime, (log2(n_sor)-1), orig_mean, pert_mean, percent);

k_best = log2(min(n_ge, n_sor)) - 1; % Subscract one since the n at termination is allready doubled.
fprintf(1, '\nThe best n, the one that works for both GE and SOR, is n=2^%i\n', k_best);