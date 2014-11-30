% Load Audio at 8kHz
[x, Fs] = wavread('voice_samp_8k.wav');
x = x';
L = length(x);
chunk_L = 48;
NFFT = 128; % NFFT / 2 is the number of samples from 0 to Fs/2

for i = 0:(L/chunk_L)-1000
    chunk = x((i*chunk_L)+1:((i+1)*chunk_L)+1);
    Y = fft(chunk,NFFT)/chunk_L;
    f = Fs/2*linspace(0,1,NFFT/2+1);

    plot(f,2*abs(Y(1:NFFT/2+1)))
    axis([0,4000,0,.5])
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    
    %pause(0.0005);
end