function PAM_laser_ardu_tx(input_message,com_port,pin,delay,tx_time)
%PAM_LASER_ARDU_TX Summary of this function goes here
%   Detailed explanation goes here
% input_message: binary array to be transmitted via laser pulse 
% com_port: "/dev/ttyUSB0" for linux and "COMn" for windows
% pin: the digital pin of arduino, example "D7"
% delay: waitime in secs
% tx_time : total time to transmit the data, if data size less it will
% repeat till this time
a_tx = arduino(com_port,"Uno");
i = 1;
j=1;
num_messages = length(input_message);
while(i<=tx_time)
    writeDigitalPin(a_tx,pin,input_message(j));
    pause(delay);
    if ((j+1)<=num_messages)
        j=j+1;
    else
        j=1;
    end
    i=i+1;

end

end

