pr1.init_task(6)

n = 8;
[A, b] = pr1.make_mat(n);
x_cor = ones(n,1);
w = 1.2;
x0 = zeros(n,1);
tol = 1e-4;
maxit = 2^10;
maxtime = Inf;

it_step = 1e-4;
lowest_iter = Inf;

result = [];
for w = 1:it_step:2
    try
        [x, iters] = pr1.sor(A, b, x_cor, w, x0, tol, maxit, maxtime);
        result = [result; w iters];
        if iters < lowest_iter
            lowest_iter = iters;
            clear best_w
            best_w = w;
        elseif iters == lowest_iter
            best_w = [best_w w];
        end
    catch ex % maxit reached.
        %fprintf(2, '%s %s', 'Exception:', ex.getReport());
    end
end

if length(best_w) == 1
    ws_str = sprintf('=%f', best_w);
else
    ws_str = sprintf('∈[%f, %f],', min(best_w), max(best_w));
end

fprintf(1, 'With a limit of %i iterations and w-resolution of %f chosen in the interval [1,2], the best relaxation parameter is w%s which gives a solution after %i iterations.\n', maxit, it_step, ws_str, lowest_iter);

fig = figure('visible','off'); % Don't display the plot.
plt = plot(result(:,1), result(:,2), 'g');
%set(fig ,'visible','on') % Enable plots again.

xlabel('Relaxation \omega')
ylabel('Iterations')
title('SOR iterations as a function of the relaxation \omega.')
saveas(plt, '../img/task6_plot.eps', 'eps')
saveas(plt, '../img/task6_plot.png', 'png')
