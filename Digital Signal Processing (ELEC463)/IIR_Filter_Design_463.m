%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Elliptical IIR Filter Design
    - Mitchel Pigsley
    - Sample Rate: 32kHz
    - Center Frequency: 7746 Hz
    - Bandwidth: 658 Hz
    - Stop Band Attenuation: 50dB
    - Passband Ripple: 1dB
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Global Variables
Fs = 32e3;
fc = 7746;
bw = 658;
ripple = 1;
sbAtten = 50;
fp1 = fc - bw/2;
fp2 = fc + bw/2;
fs1 = fp1 - bw/4;
fs2 = fp2 + bw/4;
Wn = [2*(fp1-57)/Fs,2*(fp2+57)/Fs];
Wp = [2*(fp1)/Fs,2*(fp2)/Fs];
Ws = [2*(fs1)/Fs,2*(fs2)/Fs];
N = 5;
T = 0.03;
t = 0:(1/Fs):T;

% Create elliptical bandpass filter
[b,a] = ellip(N,ripple,sbAtten,Wp);
[H_mag_coef,f1] = freqz(b,a,2^10,Fs);
[H_phase_coef,f2] = phasez(b,a,2^10,Fs);

% Create Filter Bounds
f_stop_left = [0,fs1,fs1];
mag_stop_left = [-sbAtten,-sbAtten,0];
f_stop_right = [fs2,fs2,2*fc];
mag_stop_right = [0,-sbAtten,-sbAtten];
f_pass_bottom = [fp1,fp1,fp2,fp2];
mag_pass_bottom = [-sbAtten,-ripple,-ripple,-sbAtten];
f_pass_mid = [fp1,fp2];
mag_pass_mid = [0,0];
f_pass_top = [fp1,fp2];
mag_pass_top = [ripple,ripple];

% Plot Filter Magnitude
subplot(3,1,1);
plot(f_stop_left,mag_stop_left,'r', ...
    f_stop_right,mag_stop_right,'r', ...
    f_pass_bottom,mag_pass_bottom,'g', ...
    f_pass_mid,mag_pass_mid,'g', ...
    f_pass_top,mag_pass_top,'g', ...
    f1,20*log10(abs(H_mag_coef)),'b');
axis([fs1 - 200,fs2 + 200,-sbAtten-20,ripple+1]);
title('Elliptical Filter Magnitude');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

% Plot Filter Phase
subplot(3,1,2);
plot(f2,H_phase_coef,'b');
axis([fs1 - 200,fs2 + 200,-15,15]);
title('Elliptical Filter Phase');
xlabel('Frequency (Hz)');
ylabel('Phase (Degrees)');

% Plot Filter Group Delay
subplot(3,1,3);
[gd,w] = grpdelay(b,a,n);
plot(w,gd,'b');
title('Elliptical Filter Group Delay');
xlabel('Frequency (rad/sec)');
ylabel('Group Delay');

pause

%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FILTER PERFORMANCE EVALUATION
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Create three input sinusoids in stop bands and pass band
sig1 = cos(2*pi*fs1*t);
sig2 = cos(2*pi*fc*t);
sig3 = cos(2*pi*fs2*t); 

% Filter those signals
filt1 = filter(b,a,sig1);
filt2 = filter(b,a,sig2);
filt3 = filter(b,a,sig3);

% Create Time Domain Magnitude Bounds Corresponding to Original
orig_upper_bound_t = [0,T];
orig_upper_bound_mag = [1,1];
orig_lower_bound_t = [0,T];
orig_lower_bound_mag = [-1,-1];

% Plot time until steady state
subplot(3,1,1);
plot(orig_upper_bound_t,orig_upper_bound_mag,'r',...
    orig_lower_bound_t,orig_lower_bound_mag,'r',...
    t,filt1,'b');
axis([0,0.01,-1.1,1.1]);
title('Filtered Signal in Lower Stop Band (7253 Hz)');
xlabel('Time (s)');
ylabel('Magnitude (V)');

subplot(3,1,2);
plot(orig_upper_bound_t,orig_upper_bound_mag,'r',...
    orig_lower_bound_t,orig_lower_bound_mag,'r',...
    t,filt2,'b');
axis([0,0.01,-1.1,1.1]);
title('Filtered Signal in Pass Band (7746 Hz)');
xlabel('Time (s)');
ylabel('Magnitude (V)');

subplot(3,1,3);
plot(orig_upper_bound_t,orig_upper_bound_mag,'r',...
    orig_lower_bound_t,orig_lower_bound_mag,'r',...
    t,filt3,'b');
axis([0,0.01,-1.1,1.1]);
title('Filtered Signal in Upper Stop Band (8240 Hz)');
xlabel('Time (s)');
ylabel('Magnitude (V)');

pause

% Plot Filtered Signals in Steady State
subplot(3,1,1);
plot(orig_upper_bound_t,orig_upper_bound_mag,'r',...
    orig_lower_bound_t,orig_lower_bound_mag,'r',...
    t,filt1,'b');
axis([.02,0.03,-1.1,1.1]);
title('Filtered Signal in Lower Stop Band (7253 Hz)');
xlabel('Time (s)');
ylabel('Magnitude (V)');

subplot(3,1,2);
plot(orig_upper_bound_t,orig_upper_bound_mag,'r',...
    orig_lower_bound_t,orig_lower_bound_mag,'r',...
    t,filt2,'b');
axis([.02,0.03,-1.1,1.1]);
title('Filtered Signal in Pass Band (7746 Hz)');
xlabel('Time (s)');
ylabel('Magnitude (V)');

subplot(3,1,3);
plot(orig_upper_bound_t,orig_upper_bound_mag,'r',...
    orig_lower_bound_t,orig_lower_bound_mag,'r',...
    t,filt3,'b');
axis([.02,0.03,-1.1,1.1]);
title('Filtered Signal in Upper Stop Band (8240 Hz)');
xlabel('Time (s)');
ylabel('Magnitude (V)');

pause

%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FILTER IMPULSE RESPONSE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Create impulse response
[h,ht] = impz(b,a,2^10,Fs);

% Plot impulse response
subplot(1,1,1);
plot(ht,h,'b');
axis([0,0.026,-0.05,0.05]);
title('Impulse Response of Filter');
xlabel('Time (s)');
ylabel('Magnitude (V)');

pause

%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Filter Effect on White Noise
    - Create signal of white noise
    - Filter noise
    - Plot noise before and after 
        filter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Create white noise signal
n = randn(Fs,1); 

% Filter Noise
filtNoise = filter(b,a,n);

% Plot noise before and after filter
subplot(2,1,1);
plot(10*log10(pwelch(n)),'b');
axis([0,4000,-15,ripple+1]);
title('Noise');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

subplot(2,1,2);
plot(10*log10(pwelch(filtNoise)),'b');
axis([0,4000,-80,ripple+1]);
title('Noise');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');