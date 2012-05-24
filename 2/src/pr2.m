clc % Clear command screen.
format long % Format of floating point numbers.
%format short e % Don't factor our common parts of numbers in matrices.
%clf % Clear current figure
close all  % Close all figures.
fprintf(1, '-->Project #2.\n');
clear all
%warning on verbose % See MSGIDs for warnings.
%global d_freq, d_intens;
[ d_freq,  d_intens ] = pr2.import_data('../spectrum_data.xls');

% Plot relative spectrum.
fig = figure('visible','off'); % Don't display the plot.
plot_relspectrum = plot(d_freq, d_intens, 'b');
xlabel('Frequency [Hz]')
ylabel('Relative intensity [W/(m^2*Hz)]')
title('The relative intensity spectrum.')
saveas(plot_relspectrum, '../img/spectrum_relative.eps', 'eps')
saveas(plot_relspectrum, '../img/spectrum_relative.png', 'png')
set(fig ,'visible','on') % Enable plots again.
close(fig);

% Plot spectrum
fig = figure('visible','off'); % Don't display the plot.
plot_spectrum = plot(d_freq, d_freq .* d_intens, 'b');
xlabel('Frequency [Hz]')
ylabel('Intensity [W/m^2]')
title('The intensity spectrum.')
saveas(plot_spectrum, '../img/spectrum.eps', 'eps')
saveas(plot_spectrum, '../img/spectrum.png', 'png')
set(fig ,'visible','on') % Enable plots again.
close(fig)

% Plot wavelengths spectrum.
fig = figure('visible','off'); % Don't display the plot.
ax = axes();
d_wavelen = 2.998e8 ./ d_freq; % wavelength = c / freq.
%d_wintens = d_wavelen .* d_intens;
plot_wave = plot(d_wavelen, d_intens, 'b');
spectral_color.spectrumLabel(ax);
xlabel('Wavelength [nm]')
ylabel('Intensity [W/(m^2\lambda)]')
title('Intensity spectrum.')
saveas(plot_wave, '../img/spectrum_wave.eps', 'eps')
saveas(plot_wave, '../img/spectrum_wave.png', 'png')
set(fig ,'visible','on') % Enable plots again.
close(fig)

% Try to fit polynomials to the data directly.
fig_badfit = figure('visible','off'); % Don't display the plot.
plot_badfit = plot(d_freq, d_intens, 'b');
hold on
xlabel('Frequency [Hz]')
ylabel('Relative intensity [W/(m^2*Hz)]')
title('Bad fittings to the data directly.')


warning off MATLAB:polyfit:RepeatedPointsOrRescale	% I know about the problem.
badfit2 = polyfit(d_freq, d_intens, 2);
warning on MATLAB:polyfit:RepeatedPointsOrRescale
badfit2_v = polyval(badfit2, d_freq);
plot(d_freq, badfit2_v, 'g')
plot_badfit = plot(d_freq, d_intens, 'b');
hold on

warning off MATLAB:polyfit:RepeatedPointsOrRescale
badfit3 = polyfit(d_freq, d_intens, 3);
warning on MATLAB:polyfit:RepeatedPointsOrRescale
badfit3_v = polyval(badfit3, d_freq);
plot(d_freq, badfit3_v, 'r')

saveas(plot_badfit, '../img/bad_fits.eps', 'eps')
saveas(plot_badfit, '../img/bad_fits.png', 'png')
set(fig_badfit ,'visible','on') % Enable plots again.
close(fig_badfit)



%% Try to find a fit for the underlying spectrum function by deleting the peaks and dips.
% Plot relative spectrum.
d_indices = 1:length(d_freq); % Plot by index for easier adjustments later.
fig_goodfit = figure('visible','off');
%fig_goodfit = figure();
plot_goodfit = plot(d_indices, d_intens, 'b');
hold on
xlabel('Frequency [Hz]')
ylabel('Relative intensity [W/(m^2*Hz)]')
title('Good fitting to the spectrum function.')

peaks = []; % Row i is peak/dip i counted from the left with col1 the left border and col2 the right border of the peak/dip.
% Found graphically with MATLABs data cursor in plots.
peaks(end+1,:) = [820 960];
peaks(end+1,:) = [1275 1540]; % Watch out for right boundary, deep zoom reveals heavy slope!
peaks(end+1,:) = [1560 1720];
peaks(end+1,:) = [2175 0];
peaks(end+1,:) = [0 2575];
peaks(end+1,:) = [3580 3745];

midpoints = [];
midpoints(end+1) = [881];
midpoints(end+1) = [1406];
midpoints(end+1) = [1636];
midpoints(end+1) = [2341];
midpoints(end+1) = [2380];
midpoints(end+1) = [3656];


spectrum_indices = [1:peaks(1,1)]; % Indices excluding the peaks and dips.
for i = 2:length(peaks)
	if i ~= 5 % No segment between these two dips.
		spectrum_indices = [spectrum_indices peaks(i-1,2):peaks(i,1)];
	end
end

spectrum_indices = [spectrum_indices peaks(length(peaks),2):d_indices(end)];
peak_indices = setdiff(d_indices, spectrum_indices);
spectrum_v = d_intens(spectrum_indices)';
peak_v = d_intens(peak_indices);
%plot(spectrum_indices, spectrum_v, 'g*'); % Plot the spectrum points.
plot(peak_indices, peak_v, 'r*'); % Plot points in the peak ranges, now, adjust the boudaries manually.

%% Try fitting some lines to the spectrum.
spectrum_line2 = polyfit(spectrum_indices, spectrum_v, 2);
spectrum_line2_v = polyval(spectrum_line2, spectrum_indices);
plot(spectrum_indices, spectrum_line2_v, 'k') % black

warning off MATLAB:polyfit:RepeatedPointsOrRescale	% I know about the problem now.
spectrum_line3 = polyfit(spectrum_indices, spectrum_v, 3);
warning on MATLAB:polyfit:RepeatedPointsOrRescale
spectrum_line3_v = polyval(spectrum_line3, spectrum_indices);
plot(spectrum_indices, spectrum_line3_v, 'm') % magenta


warning off MATLAB:polyfit:RepeatedPointsOrRescale
spectrum_line4 = polyfit(spectrum_indices, spectrum_v, 4);
warning on MATLAB:polyfit:RepeatedPointsOrRescale
%spectrum_line4 = polyfit((spectrum_indices - mean(spectrum_indices)) / std(spectrum_indices), spectrum_v, 4);
spectrum_line4_v = polyval(spectrum_line4, spectrum_indices);
plot(spectrum_indices, spectrum_line4_v, 'c') % cyan

% Check conditioning, see Sauer p.203.
A = [ones(length(spectrum_indices),1) spectrum_indices' spectrum_indices.^2' spectrum_indices.^3' spectrum_indices.^4'];
condition = cond(A'*A); % Ill conditioned!
fprintf(1, 'The conditon of A for the normal eqation for a polynomial fit of degree %i is %E\n', 4, condition);

% Centering and normalization to solve bad condition.
% Normalize frequencies.
d_freq_norm = (d_freq - mean(d_freq)) / std(d_freq);

saveas(plot_goodfit, '../img/spectrum_goodfit.eps', 'eps')
saveas(plot_goodfit, '../img/spectrum_goodfit.png', 'png')
set(fig_goodfit ,'visible','on') % Enable plots again.
close(fig_goodfit);
close all

spectrum_line = polyfit(d_freq_norm(spectrum_indices), d_intens(spectrum_indices), 4);
line_v = polyval(spectrum_line, d_freq_norm);
peak_intens = d_intens - line_v; % We want the area between the curves.

% Assume symmetrical spectral lines.
half_areas = zeros(6,1);
for i = 1:length(peaks)
	if i == 5 % We only have right start point
		half_areas(i) = trapz(d_freq(midpoints(i):peaks(i,2)), peak_intens(midpoints(i):peaks(i,2)));
	else
		half_areas(i) = trapz(d_freq(peaks(i,1):midpoints(i)), peak_intens(peaks(i,1):midpoints(i)));
	end
end

areas_symm = abs(2 .* half_areas);
areas_symm_str = sprintf('\t%E\n', areas_symm);
fprintf(1, 'Areas in W/m^2 found using symmetry is: \n[\n%s]\n', areas_symm_str);

% Calculate full areas for the 4 peaks we have left and right border for. The double dip (index 4) is couned as one dip.
full_areas = zeros(6,1);
for i = 1:length(peaks)
	if ~(i == 4 || i == 5) % Skip the double dip.
		full_areas(i) = trapz(d_freq(peaks(i,1):peaks(i,2)), peak_intens(peaks(i,1):peaks(i,2)));
	elseif i == 4 
		full_areas(i) = trapz(d_freq(peaks(i,1):peaks(i+1,2)), peak_intens(peaks(i,1):peaks(i+1,2)));
	end
end

% Areas found by using trapezoidal method for the whole peak/dip interval.
areas = abs(full_areas);
areas_str = sprintf('\t%E\n', areas);
fprintf(1, 'Areas found using thw whole peak/dip interval is: \n[\n%s]\n', areas_str);

% Find the largest difference in area between full and half.
areas_symm_parts = areas_symm([1:3 6]); % Skip double dip.
areas_parts = areas([1:3 6]); % Skip double dip.
area_diff = areas_symm_parts - areas_parts;
%area_norm = norm(area_diff , Inf);
[area_norm norm_pos] = max(abs(area_diff));
norm_quota = (area_norm / areas_parts(norm_pos)) * 100;
fprintf(1, 'The infinity norm of the differnce in the two set of areas (double dip excluded) is %E. That is %.3f%% of the full area.\n', area_norm, norm_quota);

dip_diff = abs(areas(4) - (areas_symm(4) + areas_symm(5)));
dip_diff_quota = (dip_diff / areas(4)) * 100;
fprintf(1, 'The difference between the full double dip area and sum of the symmetrically found individual areas are %E. The sum is %.3f%% larger than the full double dip area.\n', dip_diff, dip_diff_quota);
