%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DSB-SC Transmitter & Receiver Simulation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% constants
Fs = 48e3;
fc = 5e3;
Ac = 1;
fm = 500;
T = .05;

% generate the message signal
t = 0:(1/Fs):T;
m = cos(2 * pi * fm * t);

% transmitter

% generate carrier signal
c = Ac * cos(2 * pi * fc * t);

% DSB-SC
u = m .* c;

% channel - noiseless
r = u;

local_c_norm = cos(2 * pi * fc * t);
local_c_semi = cos(2 * pi * fc * t + (pi * 2) / 6);
local_c_worst = cos(2 * pi * fc * t + pi / 2);

% receiver
x = r .* local_c_norm;
y = r .* local_c_semi;
z = r .* local_c_worst;

load dsb_sc_lpf

% Create multi-row matrix for each output
m_out_norm = [1;0;0] * filter(dsb_sc_lpf, 1, x);
m_out_semi = [0;1;0] * filter(dsb_sc_lpf, 1, y);
m_out_worst = [0;0;1] * filter(dsb_sc_lpf, 1, z);

all_plots = m_out_norm + m_out_semi + m_out_worst;

% Plot each receiver phase
plot(all_plots');
axis([764,1053,-.6,.6]);
legend('Phase = 0','Phase = (2*pi)/6','Phase = pi/2');
title('DSB-SC Outputs for Different Local Oscillator Phases');
xlabel('Time (Samples)');
ylabel('Voltage (V)');