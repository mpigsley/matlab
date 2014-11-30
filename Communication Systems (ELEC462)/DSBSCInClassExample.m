% make a DSB-SC transmitter

% constants
Fs = 48e3;
fc = 5e3;
Ac = 1;
fm = 500;
T = 2.0;

% generate the message signal
t = 0:(1/Fs):T;
m = cos(2 * pi * fm * t);

% transmitter

% generate carrier signal
c = Ac * cos(2 * pi * fc * t);

% DSB-SC
u = m .* c;

%mySpectrum(u, Fs);

% channel - noiseless
n = 5 * randn(1, length(u));
r = u + n;

local_c = cos(2 * pi * fc * t);

% receiver
x = r .* local_c;

load dsb_sc_lpf

m_out = filter(dsb_sc_lpf, 1, x);





