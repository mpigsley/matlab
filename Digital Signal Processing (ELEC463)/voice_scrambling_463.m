%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Frequency Inversion Voice Scrambling
    - Mitchel Pigsley
    - 12/18/13
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Clean
clear all

% Global Variables
original = audioread('Audio/voice_samp_8k.wav');

original_Fs = 8e3;
freq = -original_Fs:2*original_Fs/(length(original)-1):original_Fs;
foldover = rand(1,50).*(.5)+(2/5); % Random Normalized Foldover Between .4 & .7

% Scramble the Signal with a particular foldover
scrambled = scrambler(original,foldover);
% Unscramble the signal with the same function
descrambled = scrambler(scrambled,1-foldover);

% Plot vals
subplot(3,1,1);
plot(freq,abs(fft(original)));
title('Spectrum of Original Audio Sample');
xlabel('Frequency (Hz)');
ylabel('Magnitude (V)');
subplot(3,1,2);
plot(freq,abs(fft(scrambled)));
title('Spectrum of Scrambled Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude (V)');
subplot(3,1,3);
plot(freq,abs(fft(descrambled)));
title('Spectrum of De-Scrambled Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude (V)');

% Play Signals
% soundsc(scrambled,original_Fs);
% pause on;
% pause(13);
% soundsc(descrambled,original_Fs);