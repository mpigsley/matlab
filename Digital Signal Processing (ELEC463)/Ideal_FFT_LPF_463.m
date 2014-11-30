%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FFT Implementation of "ideal" LPFn
    - Mitchel Pigsley
    - Date: 12/4/13
    - Sample Rate: 8kHz
    - Cutoff Frequency: 1kHz
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Global Varibles
Fs = 8e3;
T = 1.023875;
t = 0:(1/Fs):T;
fc = 500;
sbFreqs = 3000*rand(1,6)+1000; % 6 Random Frequencies in Stop Band

% Create Composite Signal
for len = 1:length(sbFreqs);
    if len == 1
        sigs = cos(2*pi*sbFreqs(len)*t);
    else
        sigs = sigs + cos(2*pi*sbFreqs(len)*t);
    end
end

% FFT Each Block
block_size = 1024;
for len = 0:(length(sigs)/block_size)-1
    % Compute block
    if len == 0
        fft_temp = sigs(1:(len+1)*block_size);
    else
        fft_temp = sigs(len*block_size+1 :(len+1)*block_size);
    end
    % FFT of Block
    L = length(fft_temp);
    NFFT = 2^nextpow2(L); % 1024
    Y = fft(fft_temp,NFFT)/L;
    % Filter Block
    sbFilter = cat(2,zeros(1,length(Y)*(3/8)),cat(2,ones(1,length(Y)*(1/4)),zeros(1,length(Y)*(3/8))));
    Y = Y.*sbFilter;
    % Inverse FFT
    y = ifft(Y);
    % Plot
    plot(abs(y));
    axis([0,1000,0,3e-3]);
    title('Ideal LPF on Block');
    xlabel('Time (samples)');
    ylabel('Magnitude');
end