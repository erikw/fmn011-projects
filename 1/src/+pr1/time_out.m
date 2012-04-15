function [] = time_out( mtime )
% Will throw an exception when a specified max time has elapsed
% since the first call to this function with a parameter. First call this
% function with a max time to initialize the function. Then subsequent calls
% should be argument-less and will throw an exception when the maximum wait
% time is exceeded.
import pr1.*
persistent maxtime t_start;
if nargin == 1
    maxtime = mtime;
    t_start = clock();
else
    t_now = clock();
    diff = etime(t_now, t_start);
    if  diff >= maxtime
        err_str = sprintf('Execution time exeeded; %is', diff);
        exception = MException('algo:timeout', err_str);
        throw(exception);
    end
end
end

