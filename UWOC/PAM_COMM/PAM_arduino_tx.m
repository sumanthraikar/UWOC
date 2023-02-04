clear all
a_tx = arduino("/dev/ttyUSB0","Uno");
% a_rx = arduino("/dev/ttyUSB2","Uno");
% fopen(a_rx);
%a_rx = arduino("/dev/ttyUSB1","Uno");
rx_num_samples = 20;
rx_voltages = zeros(rx_num_samples,1);
i=1;
% while i<(rx_num_samples+1)
while(1)
    writeDigitalPin(a_tx,'D7',1);
%     rx_voltages(i)=readVoltage(a_rx,'A0');
    pause(0.5);
    writeDigitalPin(a_tx,'D7',1);
%     rx_voltages(i+1) = readVoltage(a_rx,'A0');
    pause(0.5);
    i=i+2;

end


