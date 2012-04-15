pr1.init_task(7)

n = 2^3;
w = 1.2;
tol = 1e-4;
maxit = Inf;
maxtime = 5*60*60; % In seconds
pr1.time_out(maxtime);

can_solve = true;
while can_solve
	try
		[A, b] = pr1.make_mat(n);
		x_cor = ones(n,1);
		x0 = zeros(n,1);
		[x, iters] = pr1.sor(A, b, x_cor, w, x0, tol, maxit);
		fprintf(1, 'Solved for k=%i in %i iterations.\n', log2(n), iters);
		n = bitshift(n, 1);
	catch ex
		if strcmp(ex.identifier, 'algo:timeout')
			can_solve = false;
		elseif strcmp(ex.identifier, 'algo:maxit')
			can_solve = false;
		end
	end
end
fprintf(1, 'With w=%.3i systems of 2^%i unknowns can be solved with SOR under %i seconds with an iteration limit of %i.\n', w, (log2(n)-1), maxtime, maxit);
