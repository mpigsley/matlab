%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Conventional AM Transmitter & Receiver Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

%Constants
Fs = 480e3;
fc = 100e3;
Ac = 1;
fm = 500e3;
T = .0005;
a = 1;

% Create the Message Signal
t = 0:(1/Fs):T;
m = 1 + a * cos(2 * pi * fm * t);

% Create the Carrier Signal
c = Ac * cos(2 * pi * fc * t);

% Conventional AM Modulated Signal
u = m .* c;

% Noiseless Channel
r = u;

% Full-Wave Rectifier
for len = 1:length(m)
   if r(len) < 0
       r(len) = r(len) * -1;
   end
end

% Envelope Detector Simulating Parallel RC
prevUp = true;
val = 0;
m_out = zeros([1 length(m)]);
for len = 1:length(m) - 1
   % Get Direction between current and next sample
   if  r(len) < r(len+1)
       up = true;
   else
       up = false;
   end
   
   % Check to see a change in direction from up to down
   if prevUp ~= up && prevUp == true
       % Reset current value
       val = r(len) + .01;
   end
   prevUp = up;
   
   % Update m_out with a Linear Capacitor Discharching Simulation
   val = val - .01;
   m_out(len) = val;
end
% Make sure to include last value
m_out(length(m)) = val;

subplot(2,1,1);
plot(m_out);
title('DeModulated Signal (a=1)');
xlabel('Time (Samples)');
ylabel('Voltage (V)');

subplot(2,1,2);
fourierTransformMagnitudePlot(m_out,Fs);
title('DeModulated Signal Fourier Transform (a=1)');
xlabel('Frequency (Hz)')
ylabel('|X(f)|')