function decoded_bits = hydrophone_recieve_sp(song_path)
%HYDROPHONE_RECIEVE Summary of this function goes here
%   Detailed explanation goes here
%This function will read received song from song_path and decode the data
%that was transmitted using known signal correlation 

[y,fs] = audioread(song_path);
start_beep_duration = 2;
end_beep_duration = 2;
one_beep_duration = 1;
zero_beep_duration = 1;
[start_beep, ~] = text2sound('start',start_beep_duration);
[end_beep, ~] = text2sound('end', end_beep_duration);
[one_beep,~] = text2sound('one',one_beep_duration);
[zero_beep, ~] = text2sound('zero',zero_beep_duration);


number_of_samples_received = floor(length(y)/fs);
number_of_bits = number_of_samples_received-(start_beep_duration+end_beep_duration);
decoded_bits = NaN(number_of_bits,1);


filt_order = 40;
low_cutoff = 500/(fs/2);
high_cutoff = 1000/(fs/2);
[b,a] = fir1(filt_order, [low_cutoff,high_cutoff]);
y_filt = filter(b,a,y);

%detect start beeps
tic;
corr_start = xcorr(y_filt, start_beep);
corr_start = corr_start((length(corr_start)/2):end);
max_corr = max(corr_start);
threshold = 0.5*max_corr;
[~, start_idx] = findpeaks(corr_start,'MinPeakHeight',threshold, 'MinPeakDistance',1*fs);


%detect stop beeps
tic;
corr_stop = xcorr(y_filt, end_beep);
corr_stop = corr_stop((length(corr_stop)/2):end);
max_corr = max(corr_stop);
threshold = 0.5*max_corr;
[~, end_idx] = findpeaks(corr_stop,'MinPeakHeight',threshold, 'MinPeakDistance',1*fs);


%detect zero beeps
corr_zero = xcorr(y_filt, zero_beep);
corr_zero = corr_zero((length(corr_zero)/2):end);
max_corr = max(corr_zero);
threshold = 0.5*max_corr;
[~, zero_idx] = findpeaks(corr_zero,'MinPeakHeight',threshold, 'MinPeakDistance',1*fs);
% disp(['detected start time:' num2str(toc)]);

%detect one beeps
corr_one = xcorr(y_filt, one_beep);
corr_one = corr_one((length(corr_one)/2):end);
max_corr = max(corr_one);
threshold = 0.5*max_corr;
[~, one_idx] = findpeaks(corr_one,'MinPeakHeight',threshold, 'MinPeakDistance',1*fs);

bit_idxs = [zero_idx(:); one_idx(:)];
sorted_idxs = sort(bit_idxs);

for i=1:number_of_bits
    if any(zero_idx==sorted_idxs(i))
        decoded_bits(i)=0;
    elseif any(one_idx==sorted_idxs(i))
        decoded_bits(i)=1;
    end
end




end

