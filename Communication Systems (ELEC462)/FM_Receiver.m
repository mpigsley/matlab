%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FM Transmitter & Receiver Simulation
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

% Modulated Signal Creation
u1 = Ac*cos(2*pi*fc*t + 2*pi*kf1.*(cumtrapz(m)/Fs));
u2 = Ac*cos(2*pi*fc*t + 2*pi*kf2.*(cumtrapz(m)/Fs));

% FM to AM Converter
x1 = diff(u1);
x2 = diff(u2);

% Full-Wave Rectifiers
x1 = abs(x1);
x2 = abs(x2);

% Envelope Detector Simulating Parallel RC
prevUp = true;
val = 0;
x1_out = zeros([1 length(x1)]);
for len = 1:length(x1) - 1
   % Get Direction between current and next sample
   if  x1(len) < x1(len+1)
       up = true;
   else
       up = false;
   end
   
   % Check to see a change in direction from up to down
   if prevUp ~= up && prevUp == true
       % Reset current value
       val = x1(len) + .01;
   end
   prevUp = up;
   
   x1_out(len) = val;
end

% Low Pass Filters
load dsb_sc_lpf

y1 = filter(dsb_sc_lpf,1,x1_out);
y2 = filter(dsb_sc_lpf,1,x2);

% Plot Message Signal at bf1
subplot(2,2,1);
plot(detrend(y1));
axis([1000,5000,-.01,.02]);
title('Output in Time Domain (bf=1)');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(2,2,2);
fourierTransformMagnitudePlot(detrend(y1),Fs);
axis([-2e4,2e4,0,3.1e-3]);
title('Output in Frequency Domain (bf=1)');
xlabel('Frequency (Hz)');
ylabel('Voltage (V)');

% Plot Message Signal at bf2
subplot(2,2,3);
plot(detrend(y2));
axis([1000,5000,-.05,.05]);
title('Output in Time Domain (bf=10)');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(2,2,4);
fourierTransformMagnitudePlot(detrend(y2),Fs);
axis([-2e4,2e4,0,8e-3]);
title('Output in Frequency Domain (bf=10)');
xlabel('Frequency (Hz)');
ylabel('Voltage (V)');