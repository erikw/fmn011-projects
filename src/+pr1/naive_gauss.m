function [ x ] = naive_gauss( A, b, maxtime )
% A naive Gaussian elimination for the system Ax=b. maxwait it the number
% of seconds the caller is prepared to wait. If maxtime is not given it is
% assumed that the caller handles the time out self (by self calling
% time_out(maxwait)). If debug_nnz defined as a global variable (and set to
% true) the number of
% non-zero elements will be printed before and after the elimination part.
import pr1.*
if nargin == 3
    time_out(maxtime);
end
global debug_nnz

if ~exist('debug_nnz', 'var')
    debug_nnz = false;
end

n = length(A(:,1));

if debug_nnz
    fprintf(1, 'Before elimination A have %i non-zero elements', nnz(A));
end

% Elimination.
for j = 1:n-1 % For each column (of interest).
    for i = j+1:n % For each row.
        fac = A(i,j)/A(j,j); % Factor to multiply row elements with.
        b(i) = b(i) - fac * b(j);
        for t = j:n % For non-eliminated element in row i.
            A(i,t) = A(i,t) - fac * A(j,t);
        end
        time_out();
    end
end
if debug_nnz
    fprintf(1, 'and after %i.\n', nnz(A));
end

% Back-substitution.
x = zeros(n, 1);
for i = n : -1 : 1 % For each row in reverse order.
    for j = i+1:n % For each element to the right of the pivot.
        b(i) = b(i) - x(j) * A(i,j);
    end
    x(i) = b(i)/A(i,i);
	time_out();
end
end
