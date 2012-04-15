function [ means ] = multi_solve_sor( nbr_systems, n, solve_times, maxit, maxtime )
% Solves nbr_systems perturbed systems of size nxn solve_times times with SOR
% with a script timeout of maxtime and each system executing maxit times.
%
% A vector of length nbr_systems of mean solve times is returned.
import pr1.*
if nargin == 3
    maxit = Inf;
elseif nargin == 5
    time_out(maxtime);
end

means = zeros(nbr_systems, 1); % The resulting mean times.

w = 1.2;
tol = 1e-8; % TODO what to use?

[A, b] = make_mat(n);
x0 = zeros(n,1);
x_cor = ones(n,1);
% Initial guess that is close to real solution of the perturbed matrices.
x_init = sor(A, b, x_cor, w, x0, tol, maxit);

for s = 1:nbr_systems
    [Ap, bp, xp_cor] = make_perturbed_mat(n);
     times = zeros(solve_times,1); % Time measurements.

     for i = 1:solve_times
        tic_id = tic();
        sor(Ap, bp, xp_cor, w, x_init, tol, maxit);
        times(i) = toc(tic_id);
    end
    means(s) = mean(times);
end
end
