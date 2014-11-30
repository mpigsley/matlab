%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
462 Project - SNR of an FM System
    - Mitchel Pigsley
    - Date: 12/6/13
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Clean
clear all

% Load Filter Variables
load('BPFBeta5.mat')
load('BPFBeta3.mat')
load('LPF_W500.mat')

% Global Variables
Fs = 200e3;
fc = 10e3;
a = 1;
Ac = 1;
fm = 500;
T = .4;
t = 0:(1/Fs):T;
bf1 = 3;
bf2 = 5;
kf1 = (fm.*bf1)/a;
kf2 = (fm.*bf2)/a;

plot_vals = 1:15;

snrb = zeros(1,length(plot_vals));
snro3 = zeros(1,length(plot_vals));
snro5 = zeros(1,length(plot_vals));

% Create Message Signal
m = a*cos(2*pi*fm*t);

% Modulate to Create FM Signals
ut1 = fmmod(m,fc,Fs,kf1);
ut2 = fmmod(m,fc,Fs,kf2);

% Begin Calculating
for beta = bf1:bf2-bf1:bf2
    for snr = plot_vals
        % Change filter based on beta
        if beta == 3
            beta_filter = BPFBeta3;
        else
            beta_filter = BPFBeta5;
        end
        
        % Introduce Noise
        if beta == 3
            noise = GenerateAWGN(length(ut1),snr);
            ut_noisy = ut1+noise;
        else
            noise = GenerateAWGN(length(ut2),snr);
            ut_noisy = ut2+noise;
        end

        % Calcaulate baseband snr only once
        if beta == bf1
            noise_filt = filter(LPF_W500,1,noise);
            snrb(snr) = 10*log10(1/(2*(sum(noise_filt.^2)/length(noise_filt))));
        end

        % Bandpass Filter at BW = Bc
        x = filter(beta_filter,1,ut_noisy);
        
        % Plot Modulated + Noise Signal in Frequency Domain
        if snr == 1 && beta == bf2
            subplot(2,1,1);
            fourierTransformMagnitudePlot(x,Fs);
            title('Modulated Signal Under Threshold FFT','FontSize',15);
            axis([6600,13400,0,0.2]);
            xlabel('Frequency (Hz)','FontSize',13);
            ylabel('Magnitude','FontSize',13);
        elseif snr == 10 && beta == bf2
            subplot(2,1,2);
            fourierTransformMagnitudePlot(x,Fs);
            title('Modulated Signal Above Threshold FFT','FontSize',15);
            axis([6600,13400,0,0.2]);
            xlabel('Frequency (Hz)','FontSize',13);
            ylabel('Magnitude','FontSize',13);
            pause
        end

        % Demodulate
        if beta == 3
            y = fmdemod(x,fc,Fs,kf1);
        else
            y = fmdemod(x,fc,Fs,kf2);
        end

        % Lowpass Filter at BW = 500 (fm)
        y = filter(LPF_W500,1,y);

        % Remove Group Delay & Clip Vectors
        grp_delay = grpdelay(beta_filter,1)+grpdelay(LPF_W500,1)+10000;
        if snr == 2
            m_clipped = m(1:end-grp_delay+1);
        end
        y_clipped = y(grp_delay:end);

        % Plot Demodulated Signal in Time Domain
        g_bnds = [1e4 2.5e4];
        if snr == 1 && beta == bf1
            subplot(2,1,1);
            plot(y_clipped);
            axis([g_bnds(1),g_bnds(2),min(y_clipped(g_bnds(1):g_bnds(2))),max(y_clipped(g_bnds(1):g_bnds(2)))]);
            title('Demodulated Signal Under Threshold','FontSize',15);
            xlabel('Time (Samples)','FontSize',13);
            ylabel('Magnitude (Voltage)','FontSize',13);
        elseif snr == 10 && beta == bf1
            subplot(2,1,2);
            plot(y_clipped);
            axis([g_bnds(1),g_bnds(2),min(y_clipped(g_bnds(1):g_bnds(2))),max(y_clipped(g_bnds(1):g_bnds(2)))]);
            title('Demodulated Signal Above Threshold','FontSize',15);
            xlabel('Time (Samples)','FontSize',13);
            ylabel('Magnitude (Voltage)','FontSize',13);
            pause
        end
        
        % Get noise from signal
        noise_out = y_clipped-m_clipped;

        % Find power of signal
        Ps = sum(m_clipped.^2)/length(m_clipped);

        % Find power of noise
        Pn = sum(noise_out.^2)/length(noise_out);

        % Calculate SNRo and add to array
        if beta == 3
            snro3(snr) = 10*log10(Ps/Pn);
        else
            snro5(snr) = 10*log10(Ps/Pn);
        end

    end
end

% Plot Output
subplot(1,1,1);
plot(plot_vals,snrb,'g-o',plot_vals,snro3,'b->',plot_vals,snro5,'r-h','LineWidth',2);
axis([plot_vals(1),plot_vals(end),min([snro3 snro5]),max([snro3 snro5])]);
leg = legend('SNR at Baseband','SNR w/ Beta = 3','SNR w/ Beta = 5');
title('Threshold Effect on Signal Corrupted with AWGN','FontSize',20);
set(leg,'Location','SouthEast');
set(leg,'FontSize',14);
xlabel('Noise Corruption Level','FontSize',14);
ylabel('Signal to Noise Ratio','FontSize',14);
grid on;