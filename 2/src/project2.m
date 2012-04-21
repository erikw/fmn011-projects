clc % Clear command screen.
format long % Format of floating point numbers.
close all  % Close all figures.
fprintf(1, '-->Project #2.\n');
clear all

[ d_freq,  d_intens ] = pr2.import_data('../spectrum_data.xls');

% Plot relative spectrum.
fig = figure('visible','off'); % Don't display the plot.
plt_relspectrum = plot(d_freq, d_intens, 'g');
xlabel('Frequency [Hz]')
ylabel('Relative intensity [W/(m^2*Hz)]')
title('The relative intensity spectrum.')
saveas(plt_relspectrum, '../img/spectrum_relative.eps', 'eps')
saveas(plt_relspectrum, '../img/spectrum_relative.png', 'png')
set(fig ,'visible','on') % Enable plots again.
close(fig);

% Plot spectrum
fig = figure('visible','off'); % Don't display the plot.
plt_spectrum = plot(d_freq, d_freq .* (d_intens - 0), 'b');
xlabel('Frequency [Hz]')
ylabel('Intensity [W/m^2]')
title('The intensity spectrum.')
saveas(plt_spectrum, '../img/spectrum.eps', 'eps')
saveas(plt_spectrum, '../img/spectrum.png', 'png')
set(fig ,'visible','on') % Enable plots again.
close(fig)

% Plot wavelengths spectrum.
fig = figure('visible','off'); % Don't display the plot.
ax = axes();
d_wavelen = 2.998e8 ./ d_freq; % wavelength = c / freq.
d_wintens = d_wavelen .* d_intens;
plt_wave = plot(d_wavelen, d_wintens, 'b');
spectral_color.spectrumLabel(ax);
xlabel('Wavelength [nm]')
ylabel('Intensity [W/m^2]') % TODO correct?
title('Intensity spectrum.')
saveas(plt_wave, '../img/spectrum_wave.eps', 'eps')
saveas(plt_wave, '../img/spectrum_wave.png', 'png')
set(fig ,'visible','on') % Enable plots again.
close(fig)