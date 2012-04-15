pr1.init_task(5)

n = 8;
maxtime = 5*60*60; % In seconds.
pr1.time_out(maxtime);

can_solve = true;
while can_solve
    try
        [A, b] = pr1.make_mat(n);
        x = A\b;
        fprintf(1, 'Solved for k=%i.\n', log2(n));
        n = bitshift(n, 1);
        pr1.time_out();
    catch ex
        fprintf(2, '%s %s\n', 'Exception:', ex.message);
        can_solve = false;
    end
end

fprintf(1, 'Under %i seconds sparse systems of 2^%i unknowns can be solved with MATLABs backslash operator.\n', maxtime, (log2(n)-1));
