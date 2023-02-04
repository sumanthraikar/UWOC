function rx_digital_op = PAM_laser_ardu_rx(com_port,pin, rx_time,delay)
%PAM_LASER_ARDU_RX Summary of this function goes here
%   Detailed explanation goes here 
% com_port: com_port to read from
% pin: arduino pin to read from
% rx_time: total receive time in secs
% delay: delay between reading digital outputs
i=1;
rx_digital_op = ones(rx_time,1);
a_rx = arduino(com_port,"Uno");
while(i<=rx_time)
    rx_digital_op(i) = readDigitalPin(a_rx, pin);
    pause(delay)
end

end

