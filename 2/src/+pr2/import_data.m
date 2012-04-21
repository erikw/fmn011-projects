function [ d_freq,  d_intens ] = import_data( filename )
% Reads the data from the excel file filename and returns the frequencies
% d_freq and the intensities d_intens.
    warning off MATLAB:xlsread:ActiveX % I don't have Excel or Windows.
    num = xlsread(filename);
    d_freq = num(:,1);
    d_intens = num(:,2);
end