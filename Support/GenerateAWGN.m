function [noise] = GenerateAWGN(N, snr)
% function [noise] = GenerateAWGN(N, SNR)
% Required  Input:
%               SNR    - Desired SNR ratio in dB
%               N      - number of output samples to generate
%           Output:
%               noise  - AWGN scaled to produced SNR.
%
% NOTE: assumes a fixed signal power = 1

sigma = sqrt(10.0^(-snr/10.0))*2;
noise = sigma*randn(1,N);
