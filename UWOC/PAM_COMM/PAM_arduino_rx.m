clear all
a_rx = arduino("/dev/ttyUSB1","Uno");
while(1)
   
    disp(readVoltage(a_rx,'A0'))
    pause(0.5);
    disp(readVoltage(a_rx,'A0'))
    pause(0.5);

end