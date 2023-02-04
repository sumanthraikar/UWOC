function [songnote, sampling_freq] = text2sound(text, duration_of_tune)

%text: input text (small case) based on which a sound will be generated
%Sound frequencies will change with text
%sample rate: 16384 fixed
%freq : sinusoids of frequencies 500*2^(idx-1)/26
%use soundsc(songnote, sampling_freq) to play the song

tonecreate = @(alp_idx,dur,sampling_freq,alph_size) sin(2*pi* (0:dur)/sampling_freq * (500*2.^((alp_idx-1)/alph_size)));
sampling_freq = 16384;
letters = num2cell(text);
no_letters  = length(letters);
characters = num2cell('a':'z');
alph_size = length(characters);
letter_duration = (duration_of_tune*sampling_freq)/no_letters;

for k = 1:length(letters)
    idx = strcmp(letters(k), characters);
    songidx(k) = find(idx);
end 

songnote = [];
for k = 1:length(songidx)
    songnote = [songnote; [tonecreate(songidx(k),letter_duration,sampling_freq,alph_size)  zeros(1,75)]'];
end




