Fs = 48000;
T = 0.5;
t = 0:1/Fs:T;

s1 = 0.5*sin(2*pi*1000*t);
s2 = 0.5*sin(2*pi*4000*t);
input = s1 + s2;
input = round(input .* 32767);

y = filter(fir_filter_h, 1, input);
y0 = ParseCCSDatFile('G:\General Files\Code Composer Workspace\fir_filter\output.dat');

error = y(1:end-1) - y0(1:end-1);
mse = mean(error.^2) / 32767;

plot(t,y0,'b');
axis([0,0.008,-32767,32767]);
title('DSP Filtered Signal');
xlabel('Samples');
ylabel('Magnitude');