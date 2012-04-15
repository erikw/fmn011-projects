pr1.init_task(12)

solve_times = 100;
maxit = Inf;
maxtime = 5*60*60; % In seconds. This is for each test i.e. the scripts total max time is 2*maxtime.

% Find largest k for Gauss.
n = 8;
pr1.time_out(maxtime);
can_solve = true;
while can_solve
	try
		[orig_mean, pert_mean] = pr1.duosolve_gauss(n, solve_times);
		percent = (pert_mean/orig_mean) * 100;
		fprintf(1, 'Solved duo Gauss for k=%i, orig_mean=%.5fs and pert_mean=%.5fs (i.e. %.2f%% of the original mean time).\n', log2(n), orig_mean, pert_mean, percent);
		n = bitshift(n, 1);
	catch ex
		can_solve = false;
		fprintf(2, 'Can''t solve more. Time out reached. \n');
	end
end
fprintf(1, 'In %i seconds both the original and perturbed system could be solved with Gaussian elimination with a system 2^%i unknowns. For the largest system solved; orig_mean=%.5fs and pert_mean=%.5fs (i.e. %.2f%% of the original mean time).\n', maxtime, (log2(n)-1), orig_mean, pert_mean, percent);

% Find largest k for SOR.
n = 8;
pr1.time_out(maxtime);
can_solve = true;
while can_solve
	try
		[orig_mean, pert_mean] = pr1.duosolve_sor(n, solve_times, maxit);
		percent = (pert_mean/orig_mean) * 100;
		fprintf(1, 'Solved duo SOR for k=%i, orig_mean=%.5fs and pert_mean=%.5fs (i.e. %.2f%% of the original mean time).\n', log2(n), orig_mean, pert_mean, percent);
		n = bitshift(n, 1);
	catch ex
		can_solve = false;
        fprintf(2, 'Can''t solve more. Time out reached. \n');
	end
end
fprintf(1, 'In %i seconds both the original and perturbed system could be solved with SOR with a system 2^%i unknowns. For the largest system solved; orig_mean=%.5fs and pert_mean=%.5fs (i.e. %.2f%% of the original mean time).\n', maxtime, (log2(n)-1), orig_mean, pert_mean, percent);
