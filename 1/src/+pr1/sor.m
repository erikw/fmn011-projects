function [ x, iters] = sor( A, b, x_cor, w, x0, tol, maxit, maxtime )
% To the system Ax=b, this function will iteratively find the solution x
% given a tolerance of error to the given known solution x_cor.
% A - n by n matrix.
% b - Column vector of n elements.
% x_cor - The correct solution to the system used with tol.
% w - Relaxation parameter typically > 1.
% tol - The error tolerance.
% maxit - Maximum number of iterations. Default is infinity;
% maxtime - Maximum number of seconds to wait for finish. If exceeded an
% exception is thrown. If not given the caller is assumed to handle the
% time out.
%
% Returns the approximate solution x and the number of iterations needed.
% Exception is thrown if the number of iterations exceeds maxit.
import pr1.*
if nargin == 6
	maxit = Inf;
elseif nargin == 8
    time_out(maxtime);
end

n = length(A);
D = spdiags(diag(A),0,n,n);
L = tril(A, -1);
U = triu(A, 1);
iters = 0;
x = sparse(x0);
wLD = w*L + D;
% wLDinv = wLD\eye(n);

while (norm(x - x_cor, Inf) > tol) && (iters < maxit)
%     x = wLDinv*(((1-w)*D*x - w*U*x) + w*b);
    x = wLD\(((1-w)*D*x - w*U*x) + w*b);
    iters = iters + 1;
    time_out();
end

if iters == maxit
    err_str = sprintf('Maximum number of iterations exceeded; iters=%i', iters);
    exception = MException('algo:maxit', err_str);
    throw(exception);
end
end
