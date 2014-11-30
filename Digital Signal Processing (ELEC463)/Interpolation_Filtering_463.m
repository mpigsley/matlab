%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Interpolation Filters
    Read & Upsample an Audio file,
    then use interpolation filtering
    - No Interpolation Filtering
    - Hold Interpolation
    - Linear Interpolation
    - Lowpass Interpolation (Short)
    - Lowpass Interpolation (Long)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Global Variables
original = audioread('Audio/voice_samp_8k.wav');
original_Fs = 8e3;
L = 4;

% Plot Original
stem(original);
axis([1800,1825,-1,1]);
title('Original Signal');
xlabel('Samples');
ylabel('Magnitude (V)');

pause

%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     No Interpolation Filtering
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Zero Pad Original
zero_pad_original = reshape([original zeros(length(original),L-1)]',L*length(original),1);

% Plot Upsampled Version
stem(zero_pad_original);
axis([1800*L,1825*L,-1,1]);
title('Upsampled Version with no Interpolation');
xlabel('Samples');
ylabel('Magnitude (V)');

% Play Sound
% soundsc(zero_pad_original,original_Fs*L);
pause

%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Hold Interpolation Filtering
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Zero Pad Original
zero_pad_original = reshape([original zeros(length(original),L-1)]',L*length(original),1);

% Apply Hold Interpolation Filtering
hold_inter = zero_pad_original;
curr_val = hold_inter(1);
for len = 1:length(hold_inter) - 1
    if (mod(len-1,L) == 0)
        curr_val = hold_inter(len);
    else
        hold_inter(len) = curr_val;
    end
end

% Plot Upsampled Version
stem(hold_inter);
axis([1800*L,1825*L,-1,1]);
title('Upsampled Version with Hold Interpolation');
xlabel('Samples');
ylabel('Magnitude (V)');

% Play Sound
% soundsc(hold_inter,original_Fs*L);
pause

%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Linear Interpolation Filtering
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Zero Pad Original
zero_pad_original = reshape([original zeros(length(original),L-1)]',L*length(original),1);

% Apply Hold Interpolation Filtering
lin_inter = zero_pad_original;
curr_val = lin_inter(1);
curr_interval = 0;
for len = 1:length(lin_inter) - L - 1
    if (mod(len-1,L) == 0)
        curr_val = lin_inter(len);
        curr_interval = (lin_inter(len+L) - lin_inter(len))/L;
    else
        curr_val = curr_val + curr_interval;
        lin_inter(len) = curr_val;
    end
end

% Plot Upsampled Version
stem(lin_inter);
axis([1800*L,1825*L,-1,1]);
title('Upsampled Version with Linear Interpolation');
xlabel('Samples');
ylabel('Magnitude (V)');

% Play Sound
% soundsc(lin_inter,original_Fs*L);
pause

%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Lowpass Interpolation (Short)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Zero Pad Original
zero_pad_original = reshape([original zeros(length(original),L-1)]',L*length(original),1);

% Lowpass Interpolation
N = 8;
Wn = pi/L;
filt_coef = fir1(N,Wn);
lowpass_filt = filter(filt_coef,1,zero_pad_original);

% Calculate & Apply Group Delay
grp_delay = N/2;
lowpass_filt = lowpass_filt(grp_delay:end);

% Plot Upsampled Version
stem(lowpass_filt);
axis([1800*L,1825*L,-1,1]);
title('Upsampled Version with LowPass Interpolation (Short)');
xlabel('Samples');
ylabel('Magnitude (V)');

% Play Sound
% soundsc(lowpass_filt,original_Fs*L);
pause

%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Lowpass Interpolation (Long)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Zero Pad Original
zero_pad_original = reshape([original zeros(length(original),L-1)]',L*length(original),1);

% Lowpass Interpolation
N = 2048;
Wn = pi/L;
filt_coef = fir1(N,Wn);
lowpass_filt = filter(filt_coef,1,zero_pad_original); 

% Calculate & Apply Group Delay
grp_delay = N/2;
lowpass_filt = lowpass_filt(grp_delay:end);

% Plot Upsampled Version
stem(lowpass_filt);
axis([1800*L,1825*L,-1,1]);
title('Upsampled Version with LowPass Interpolation (Long)');
xlabel('Samples');
ylabel('Magnitude (V)');

% Play Sound
% soundsc(lowpass_filt,original_Fs*L);