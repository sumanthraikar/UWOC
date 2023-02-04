function out = hydro_tx(message, sps, mod_freq, transmit_duration)
%HYDRO_TX Summary of this function goes here
%   Detailed explanation goes here
% message: binary data to transmit
% sps: samples per symbol
% mod_freq: modulation frequency
% transmit_duration: transmit duration in seconds

interpolated_message = repelem(message, sps);
F_samp = length(interpolated_message);
t = 0:1/F_samp:1;
signal = sin(2*pi*mod_freq*t);
tx_signal = signal;







end

