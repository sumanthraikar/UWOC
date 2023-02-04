clc;
clear all;
[y,fs] = audioread('test_song.wav');
start_beep_duration = 2;
end_beep_duration = 2;
one_beep_duration = 1;
zero_beep_duration = 1;
[start_beep, ~] = text2sound('start',start_beep_duration);
[end_beep, ~] = text2sound('end', end_beep_duration);
[one_beep,~] = text2sound('one',one_beep_duration);
[zero_beep, ~] = text2sound('zero',zero_beep_duration);

% corr1 = xcorr(zero_beep, start_beep);
% corr1 = corr1((length(corr1)/2):end);
% plot(corr1);
% disp(max(corr1));

% filt_order = 100;
% low_cutoff = 500/(fs/2);
% high_cutoff = 1000/(fs/2);
% [b,a] = fir1(filt_order, [low_cutoff,high_cutoff], 'bandpass');
% freqz(b,a, 1000, fs)
% y_filt = filter(b,a,y);

%detect start beeps
tic;
corr_start = xcorr(y, one_beep);
corr_start = corr_start((length(corr_start)/2):end);
plot(corr_start);
max_corr = max(corr_start);
threshold = 0.5*max_corr;
[~, start_idx] = findpeaks(corr_start,'MinPeakHeight',threshold, 'MinPeakDistance',1*fs);
disp(['detected start time:' num2str(toc)]);

%detect start beeps


