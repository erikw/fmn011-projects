function [ A, b x ] = make_perturbed_mat( n, dia_elems )
% Will construct a perturbation system of the original Ax=b. Random quantities
% in the range [-e^-4, e^4] will be added to the diagonal elements of A and
% to the elements of b. The new system is A_p*x=b_p which is returned by
% the function.
import pr1.* % Behave like packages in other languages :@
if nargin == 1
	dia_elems = [-1 3 -1 0.5];
end

quantities = rand(1,5)*2e-4 - 1e-4;
dia_elems = dia_elems + quantities(1:end-1);
[A, b] = make_mat(n, dia_elems);
b = b + quantities(end);
x = A\b;
end
