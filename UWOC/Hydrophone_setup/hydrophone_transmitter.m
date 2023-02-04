function [playlist, transmit_duration, Fs] = hydrophone_transmitter(binary_message)
%HYDROPHONE_TRANSMITTER Summary of this function goes here
%   Detailed explanation goes here
% Communication starts with a "start" beep of 2 sec and stops with 
% "end" beep of 2 secs and all the information transfer happens between
% these beep sounds
% We use "one" beep for binary 1 for 1 sec
% We use "zero beep for binary 0 for 1 sec
start_beep_duration = 2;
end_beep_duration = 2;
one_beep_duration = 1;
zero_beep_duration = 1;
[start_beep, Fs] = text2sound('start',start_beep_duration);
[end_beep, ~] = text2sound('end', end_beep_duration);
[one_beep,~] = text2sound('one',one_beep_duration);
[zero_beep, ~] = text2sound('zero',zero_beep_duration);
no_of_ones = length(binary_message(binary_message==1));
no_of_zeros = length(binary_message(binary_message==0));

transmit_duration = (start_beep_duration+end_beep_duration+ (no_of_ones*one_beep_duration)+(no_of_zeros*zero_beep_duration));

playlist=[];

for k=1:length(binary_message)
    if binary_message(k)==1
        playlist = [playlist; one_beep];
    elseif binary_message(k)==0
        playlist = [playlist; zero_beep];
    
    end


end
playlist = [start_beep; playlist];
playlist = [playlist; end_beep];



end

