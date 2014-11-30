%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FM Transmitter Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Receiver
Fs = 1e6;
fc = 20e3;
T = .03;
Ac = 1;
bf1 = 1;
bf2 = 10;

% Message Signal
a = 1;
fm = 500;
t = 0:(1/Fs):T;
m = a*cos(2*pi*fm*t);
kf1 = (fm.*bf1)/a;
kf2 = (fm.*bf2)/a;

% Plot Message Signal
subplot(3,2,1);
plot(m);
axis([0,3e4,-1.1,1.1]);
title('Message Signal in Time Domain');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(3,2,2);
fourierTransformMagnitudePlot(m,Fs);
axis([-2000,2000,0,0.5]);
title('Message Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Voltage (V)');

% Modulated Signal Creation
u1 = Ac*cos(2*pi*fc*t + 2*pi*kf1.*(cumtrapz(m)/Fs));
u2 = Ac*cos(2*pi*fc*t + 2*pi*kf2.*(cumtrapz(m)/Fs));

% Plot Message Signal at bf1
subplot(3,2,3);
plot(u1);
axis([0,2000,-1.1,1.1]);
title('Modulted Signal in Time Domain (bf=1)');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(3,2,4);
fourierTransformMagnitudePlot(u1,Fs);
axis([1.8e4,2.2e4,0,.35]);
title('Modulted Signal in Frequency Domain (bf=1)');
xlabel('Frequency (Hz)');
ylabel('Voltage (V)');

% Plot Message Signal at bf2
subplot(3,2,5);
plot(u2);
axis([0,2000,-1.1,1.1]);
title('Modulted Signal in Time Domain (bf=10)');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(3,2,6);
fourierTransformMagnitudePlot(u2,Fs);
axis([1.3e4,2.7e4,0,.2]);
title('Modulted Signal in Frequency Domain (bf=10)');
xlabel('Frequency (Hz)');
ylabel('Voltage (V)');