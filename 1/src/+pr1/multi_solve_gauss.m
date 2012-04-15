function [ means ] = multi_solve_gauss( nbr_systems, n, solve_times, maxtime )
% Solves nbr_systems perturbed systems of size nxn solve_times times with GE 
% with a script timeout of maxtime.
%
% A vector of length nbr_systems of mean solve times is returned.
import pr1.*
if nargin == 4
    time_out(maxtime);
end

means = zeros(nbr_systems, 1);  % The resulting mean times.

for s = 1:nbr_systems
    [Ap, bp] = make_perturbed_mat(n); % Ignore the correct solution x.
    times = zeros(solve_times,1);

    for i = 1:solve_times
        tic_id = tic();
        naive_gauss(Ap, bp);
        times(i) = toc(tic_id);
    end
    means(s) = mean(times);
end
end
