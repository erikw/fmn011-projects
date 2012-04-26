clc % Clear command screen.
format long % Format of floating point numbers.
format short e % Don't factor our common parts of numbers in matrices.
clf % Clear current figure
%close all  % Close all figures.
fprintf(1, '-->Project #2.\n');
clear all
%global d_freq, d_intens;
[ d_freq,  d_intens ] = pr2.import_data('../spectrum_data.xls');

%% Plot relative spectrum.
%fig = figure('visible','off'); % Don't display the plot.
%plot_relspectrum = plot(d_freq, d_intens, 'b');
%xlabel('Frequency [Hz]')
%ylabel('Relative intensity [W/(m^2*Hz)]')
%title('The relative intensity spectrum.')
%saveas(plot_relspectrum, '../img/spectrum_relative.eps', 'eps')
%saveas(plot_relspectrum, '../img/spectrum_relative.png', 'png')
%set(fig ,'visible','on') % Enable plots again.
%close(fig);
%
%% Plot spectrum
%fig = figure('visible','off'); % Don't display the plot.
%plot_spectrum = plot(d_freq, d_freq .* d_intens, 'b');
%xlabel('Frequency [Hz]')
%ylabel('Intensity [W/m^2]')
%title('The intensity spectrum.')
%saveas(plot_spectrum, '../img/spectrum.eps', 'eps')
%saveas(plot_spectrum, '../img/spectrum.png', 'png')
%set(fig ,'visible','on') % Enable plots again.
%close(fig)
%
%% Plot wavelengths spectrum.
%fig = figure('visible','off'); % Don't display the plot.
%ax = axes();
%d_wavelen = 2.998e8 ./ d_freq; % wavelength = c / freq.
%d_wintens = d_wavelen .* d_intens;
%plot_wave = plot(d_wavelen, d_wintens, 'b');
%spectral_color.spectrumLabel(ax);
%xlabel('Wavelength [nm]')
%ylabel('Intensity [W/m^2]') % TODO correct?
%title('Intensity spectrum.')
%saveas(plot_wave, '../img/spectrum_wave.eps', 'eps')
%saveas(plot_wave, '../img/spectrum_wave.png', 'png')
%set(fig ,'visible','on') % Enable plots again.
%close(fig)
%


%% Try fitt polynomials to the data directly.
%fig_badfit = figure('visible','off'); % Don't display the plot.
%plot_badfit = plot(d_freq, d_intens, 'b');
%hold on
%xlabel('Frequency [Hz]')
%ylabel('Relative intensity [W/(m^2*Hz)]')
%title('Bad fittings to the data directly.')


%badfit2 = polyfit(d_freq, d_intens, 2)
%badfit2_v = polyval(badfit2, d_freq);
%plot(d_freq, badfit2_v, 'g')
%plot_badfit = plot(d_freq, d_intens, 'b');
%hold on

%badfit3 = polyfit(d_freq, d_intens, 3)
%badfit3_v = polyval(badfit3, d_freq);
%plot(d_freq, badfit3_v, 'r')

%saveas(plot_badfit, '../img/bad_fits.eps', 'eps')
%saveas(plot_badfit, '../img/bad_fits.png', 'png')
%set(fig_badfit ,'visible','on') % Enable plots again.
%close(fig_badfit)



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

% Left and right boundary for the peaks. Found manually by adjusting and testing.
%peak1 = [865 900];
%dip1 = [1380 1430];
%peak2 = [1625 1650];
%dip23 = [2290 2440];
%peak3 = [3640 3675];
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


%spectrum_indices = [1:peak1(1) peak1(2):dip1(1)]; % Exclude the peak and dips.
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
%plot(spectrum_indices, spectrum_v, 'r*');
plot(peak_indices, peak_v, 'r*'); % Plot points in the peak ranges, now, adjust the boudaries manually.
%saveas(plot_goodfit, '../img/spectrum_peaks.eps', 'eps')
%saveas(plot_goodfit, '../img/spectrum_peaks.png', 'png')

% Try fitting some lines to the spectrum.
spectrum_line2 = polyfit(spectrum_indices, spectrum_v, 2);
spectrum_line2_v = polyval(spectrum_line2, spectrum_indices);
plot(spectrum_indices, spectrum_line2_v, 'k') % black

spectrum_line3 = polyfit(spectrum_indices, spectrum_v, 3);
% Check conditioning, see Sauer p.203.
%A = [spectrum_indices.^0, spectrum_indices.^1, spectrum_indices.^2, spectrum_indices.^3, spectrum_indices.^4];
%condn = cond(A'*A)

spectrum_line3_v = polyval(spectrum_line3, spectrum_indices);
plot(spectrum_indices, spectrum_line3_v, 'm') % magenta

spectrum_line4 = polyfit(spectrum_indices, spectrum_v, 4);
spectrum_line4_v = polyval(spectrum_line4, spectrum_indices);
plot(spectrum_indices, spectrum_line4_v, 'c') % cyan

spectrum_line = spectrum_line4;
spectrum_line_v = spectrum_line4_v;
% TODO calc error of fitings or just take line4?

saveas(plot_goodfit, '../img/spectrum_goodfit.eps', 'eps')
saveas(plot_goodfit, '../img/spectrum_goodfit.png', 'png')
set(fig_goodfit ,'visible','on') % Enable plots again.
close(fig_goodfit);
close all

line_v = polyval(spectrum_line4, d_indices);
peak_intens = d_intens' - line_v; % We want the arean between the curves.

% Assume symmetrical spectral lines.
half_areas = zeros(6,1);
for i = 1:length(peaks)
	if i == 5 % We only have right start point
		half_areas(i) = trapz(d_freq(midpoints(i):peaks(i,2)), peak_intens(midpoints(i):peaks(i,2)));
	else
		half_areas(i) = trapz(d_freq(peaks(i,1):midpoints(i)), peak_intens(peaks(i,1):midpoints(i)));
	end
end

% The final answer.
areas = abs(2 .* half_areas)


