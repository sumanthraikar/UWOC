clc;
clear all;

functions = {@PAM_laser_ardu_tx, @PAM_laser_ardu_rx};
%-------------------------Transmitter parameters---------------------
message_size = 16;
input_message = randi([0 1],1, message_size);
tx_com_port = "/dev/ttyUSB0";
tx_pin = "D7";
delay = 0.5;
tx_time = 60;

%--------------------------Receiver parameters---------------
rx_comport = "/dev/ttyUSB1";
rx_pin = "D4";
solution = cell(1,2);

%----------------------------Control--------------------
parfor i = 1:2
    if i==1
        functions{1}(input_message, tx_com_port,tx_pin, delay, tx_time);
    else
        rx_output = functions{2}(rx_comport, rx_pin, tx_time, delay)
    end
end







