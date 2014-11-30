%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Zero-Padding & Non-Exact Frequencies
    - Mitchel Pigsley
    - Date: 12/4/13
    - Sample Rate: 8kHz
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Global Variables
Fs = 8e3;

% Generate Exact Sinusoids
T = 0.015875;
t = 0:(1/Fs):T;
f = 630;
sig128 = cos(2*pi*f*t);
T = .031875;
t = 0:(1/Fs):T;
sig256 = cos(2*pi*f*t);
sig256Padding = [sig128 zeros(1,128)];
sig1024Padding = [sig128 zeros(1,896)];

subplot(2,2,1);
fourierTransformMagnitudePlot(sig128,Fs);
axis([-2000,2000,0,.5]);
title('128 Samples');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(2,2,2);
fourierTransformMagnitudePlot(sig256,Fs);
axis([-2000,2000,0,.5]);
title('256 Samples');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(2,2,3);
fourierTransformMagnitudePlot(sig256Padding,Fs);
axis([-2000,2000,0,.5]);
title('256 Samples w/ 128 Samples not Zero-Padded');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(2,2,4);
fourierTransformMagnitudePlot(sig1024Padding,Fs);
axis([-2000,2000,0,.5]);
title('1024 Samples w/ 128 Samples not Zero-Padded');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

pause


% Generate Non-Exact Sinusoids
T = 0.015875;
t = 0:(1/Fs):T;
f = 600;
sig128 = cos(2*pi*f*t);
T = .031875;
t = 0:(1/Fs):T;
sig256 = cos(2*pi*f*t);
sig256Padding = [sig128 zeros(1,128)];
sig1024Padding = [sig128 zeros(1,896)];

subplot(2,2,1);
fourierTransformMagnitudePlot(sig128,Fs);
axis([-2000,2000,0,.5]);
title('128 Samples');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(2,2,2);
fourierTransformMagnitudePlot(sig256,Fs);
axis([-2000,2000,0,.5]);
title('256 Samples');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(2,2,3);
fourierTransformMagnitudePlot(sig256Padding,Fs);
axis([-2000,2000,0,.5]);
title('256 Samples w/ 128 Samples not Zero-Padded');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(2,2,4);
fourierTransformMagnitudePlot(sig1024Padding,Fs);
axis([-2000,2000,0,.5]);
title('1024 Samples w/ 128 Samples not Zero-Padded');
xlabel('Frequency (Hz)');
ylabel('Magnitude');