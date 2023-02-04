# UWOC
Codes for underwater communication

Acoustic based underwater communication setup
In this setup, we have a Matlab environment connected to both transmitter and receiver hydrophones. At the transmitter, the matlab environment converts text containing alphabets to a tune. This is done by uniquely mapping every alphabet ${i \in \{a, b, \ldots, z\} \to \sin(2\pi\frac{\omega_i}{F_s}t})$, where F_s=16KHz is the sampling frequency and $\omega_i$, $\forall i$ is in the range $500$ - $1000$Hz. Based on the input sequence of alphabets it will sequentially arrange all sinusoidal samples which are then played as a tune on the transmitter hydrophone.
The receiver just records the sequence of tune it receives. Assuming the receiver knows the mapping $\omega_i$, it uses correlation to decode the alphabets $i$ from the recorded sequence.
This is an example of a classical design where we co-design the transmitter and receiver. Our goal is to use the collected data to train neural network based encoder and decoders.


Laser based underwater communication setup
We have PAM based comm setup for laser controlled using an arduino. The transmitter has laser switching module connected to an arduino. The receiver consists of a photodiode controlled using an independent and physically separated arduino from transmitter. 
