pr1.init_task(4)

% How to batch-run:
%j = batch('task4');
%wait(j);
%diary(j);
%load(j);

n = 8;
maxtime = 5*60*60; % In seconds.
global debug_nnz;
debug_nnz = true;
pr1.time_out(maxtime);

can_solve = true;
while can_solve
    try
        [A, b] = pr1.make_mat(n);
        x = pr1.naive_gauss(A, b);
        fprintf(1, 'Solved for k=%i.\n', log2(n));
        n = bitshift(n, 1);
    catch ex
        fprintf(1, '%s %s\n', 'Exception:', ex.message);
        can_solve = false;
    end
end
fprintf(1, 'Under %i seconds sparse systems of 2^%i unknowns can be solved with naive Gaussian elimination.\n', maxtime, (log2(n)-1));
