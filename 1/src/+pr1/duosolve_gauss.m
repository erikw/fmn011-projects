function [ orig_mean, pert_mean ] = duosolve_gauss( n, solve_times, maxtime )
% Solves two systems of n unknowns with Gaussian elimination: Ax=b and a
% perturbed
% version A_p*x=b_p solve_times times and returns the mean time of solving
% these. A maximum waiting time can be specified in seconds.
%
% Returns the mean times of the original and perturbed systems.
import pr1.*
if nargin == 3
	time_out(maxtime);
end

[A, b] = make_mat(n);
[Ap, bp] = make_perturbed_mat(n); % Ignore the correct solution x.

times = zeros(solve_times,2);
for i = 1:solve_times
	% Original system.
	tic_id = tic();
	naive_gauss(A, b);
	times(i,1) = toc(tic_id);

	% Perturbed system.
	tic_id = tic();
	naive_gauss(Ap, bp);
	times(i,2) = toc(tic_id);
end
orig_mean = mean(times(:,1));
pert_mean = mean(times(:,2));
end
