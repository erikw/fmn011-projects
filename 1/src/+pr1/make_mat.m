function [ A, b ] = make_mat( n, dia_elems )
% Makes a n by n sparse matrix according to the assignment. The diagonal
% elements are provided in order of enumeration in the assignment. b is
% chosen as b = Ax where x is [1 ... 1]'. Default argument for dia_elems
% exists.
if nargin == 1
	dia_elems = [-1 3 -1 0.5];
end

e = ones(n, 1);
elems = zeros(n, length(dia_elems));
for i=1:length(dia_elems)
    elems(:, i) = dia_elems(i) * e;
end

% First create a sparse matrix with dia_elems(end) along the diagonal.
A = sparse(n,n);
A = spdiags(elems(:,end), 0, A);

% Then flip the matrix and add the rest of the elements in dia_elems along
% the new main diagonal.
A = fliplr(A);
A = spdiags(elems(:,1:end-1), -1:1, A);

% Define b as the solution to A[1 1 1..]'.
x = ones(n, 1);
b = A*x;
end
