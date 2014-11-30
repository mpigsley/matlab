%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Conventional AM Transmitter Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

%Constants
Fs = 480e3;
fc = 100e3;
Ac = 1;
fm = 500e3;
T = .0003;
a = [.2;.8];

% Create the Message Signals
t = 0:(1/Fs):T;
m = 1 + a * cos(2 * pi * fm * t);

% Create the Carrier Signal
c = Ac * cos(2 * pi * fc * t);

% Conventional AM Modulated Signals
u_1 = m(1,:) .* c;
u_2 = m(2,:) .* c;

subplot(4,2,1);
plot(m(1,:));
axis([0,145,0,1.3]);
title('Message Signal (a=0.2)');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(4,2,2);
plot(u_1);
axis([0,145,-1.3,1.3]);
title('Modulated Signal (a=0.2)');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(4,2,3);
fourierTransformMagnitudePlot(m(1,:),Fs);
axis([-2e5,2e5,0,1.1]);
title('Message Signal Fourier Transform (a=0.2)');
xlabel('Frequency (Hz)')
ylabel('|X(f)|')

subplot(4,2,4);
fourierTransformMagnitudePlot(u_1,Fs);
axis([-2e5,2e5,0,1.1]);
title('Modulated Signal Fourier Transform (a=0.2)');
xlabel('Frequency (Hz)')
ylabel('|X(f)|')

subplot(4,2,5);
plot(m(2,:));
axis([0,145,0,2]);
title('Message Signal (a=0.8)');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(4,2,6);
plot(u_2);
axis([0,145,-2,2]);
title('Modulated Signal (a=0.8)');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(4,2,7);
fourierTransformMagnitudePlot(m(2,:),Fs);
axis([-2e5,2e5,0,1.1]);
title('Message Signal Fourier Transform (a=0.8)');
xlabel('Frequency (Hz)')
ylabel('|X(f)|')

subplot(4,2,8);
fourierTransformMagnitudePlot(u_2,Fs);
axis([-2e5,2e5,0,1.1]);
title('Modulated Signal Fourier Transform (a=0.8)');
xlabel('Frequency (Hz)')
ylabel('|X(f)|')