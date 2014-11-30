% Conv AM transmitter and receiver

% constants
Fs = 480e3;
fc = 100e3;
Ac = 1;
fmt = 500;
T = 1.0;        % time in seconds
a = 0.5;        % modulation index

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate message signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% m(t) is a sinusoid at fmt Hz
t = 0:(1/Fs):T;
m = cos(2*pi*fmt*t);

% mn(t) = m(t)/max(m(t))
mn = m/max(m); 

%%%%%%%%%%%%%%%%%%%
%%% transmitter 
%%%%%%%%%%%%%%%%%%%

% c(t) is Ac * cos(2*pi*fc*t)
c = Ac * cos(2 * pi * fc * t);

% ut = Ac(1 + a*mn(t)) * ct
u = Ac .* (1 + a*mn) .* c;

% Look at spectrum of u(t) using the DFT
mySpectrum(u, Fs);

%%%%%%%%%%%%%%%%%%%
%%% Channel %%%
%%%%%%%%%%%%%%%%%%%
r = u;

%%%%%%%%%%%%%%%%%%%
%%% receiver
%%%%%%%%%%%%%%%%%%%

% half-wave rectify 
x = r;
for i = 1:length(x)
    if (x(i) < 0)
        x(i) = 0;
    end
end
%x = abs(r);

% LPF x(t) to recover m(t) (cut-off = 500 Hz, RC = 3.1831e-4)
[b, a] = rc_filter(1, 3.1831e-4, Fs, 'low');
freqz(b, a, 4096, Fs);

mt_output = filter(b, a, x);

% Look at spectrum of recovered m(t)
mySpectrum(mt_output, Fs);

% plot recovered m(t)
figure(3)
plot(mt_output);
