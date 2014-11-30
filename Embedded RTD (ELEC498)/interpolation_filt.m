% 8k -> 48k
load('G:\General Files\Matlab\Audio\TV02_8ksps.mat');
noise = (rand(1000,1)-0.5)*2;

subplot(2,1,1);
fourierTransformMagnitudePlot(noise', 8000);
title('Fourier Transform of Noise');
xlabel('Frequency (Hz)');
ylabel('Magnitude (V)');

alpha = 0.5;
l = 6;
p = 2;

h = intfilt(l, p, alpha);
x = reshape([noise zeros(length(noise),5)]',6*length(noise),1);
y = filter(h,1,x);


subplot(2,1,2);
fourierTransformMagnitudePlot(y', 8000);
title('Fourier Transform after Interpolation');
xlabel('Frequency (Hz)');
ylabel('Magnitude (V)');