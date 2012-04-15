function []= init_task( task_number )
% Initialize a task with the number task_number by clearing variables, globals functions etc. in the workspace.
clc % Clear command screen.
format long % Format of floating point numbers.
close all  % Close all figures.
fprintf(1, '-->Task #%i.\n', task_number);
evalin('caller', 'clear all'); % Clear workspace at the caller.
end