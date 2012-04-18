function [ orig_mean, pert_mean ] = duosolve_sor( n, solve_times, maxit, maxtime )
% Solves two systems of n unknowns with SOR: Ax=b and a perturbed
% version A_p*x=b_p solve_times times and returns the mean time of solving
% these. The solution to the normal system will be the initial start values
% for the perturbed system.  Maximum number of iterations and time to wait
% can be specified. If not, it is assumed that the caller handles the time out.
%
% Returns the mean times of the original and perturbed systems.
import pr1.*
if nargin == 2
	maxit = Inf;
elseif nargin == 4
    time_out(maxtime);
end

w = 1.2;
tol = 1e-8; % TODO what to use?
x0 = zeros(n,1);

[A, b] = make_mat(n);
x_cor = ones(n,1);
[Ap, bp, xp_cor] = make_perturbed_mat(n);

times = zeros(solve_times,2); % Time measurements.
for i = 1:solve_times
	% Original system.
	tic_id = tic();
	[x, iters] = sor(A, b, x_cor, w, x0, tol, maxit);
	times(i,1) = toc(tic_id);
	%fprintf(1, 'Solved original in %i iterations and %.5f seconds.\n', iters, times(i,1));

	% Perturbed system.
	tic_id = tic();
	[xp, itersp] = sor(Ap, bp, xp_cor, w, x, tol, maxit); % Initial guess is solution from above.
	times(i,2) = toc(tic_id);
	%fprintf(1, 'Solved perturbed in %i iterations and %.5f seconds.\n', itersp, times(i,2));
end
orig_mean = mean(times(:,1));
pert_mean = mean(times(:,2));
end