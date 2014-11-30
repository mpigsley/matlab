%{
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Fast Convolution on a Data Stream
    - Mitchel Pigsley
    - Date: 12/4/13
    - Type: Overlap-Add
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}

% Global Variables
Fs = 8e3;
P = 1000;
L = 3097;
N = L + P - 1;
blocks = 10;
Wn = .5;

% Create White Noise Signal
noisySig = rand(L*blocks,1);

% FIR Filter
impResponse = fir1(P,Wn)';
filtTransform = freqz(impResponse,1,N);

% Perform Overlap-Add
for len = 0:blocks-1
    if len == 0
        % Perform fft of block & Multiply with Filter
        block = fft([noisySig(1:L)' zeros(1,P)]',N);
        
    else
        % Perform fft of block & Multiply with Filter
        newBlock = fft([noisySig((len*L)+1:(len+1)*L)' zeros(1,P)]',N);
        
        % Combine back into xblock
        block = [block(1:length(block)-P)'... % Beginning Section
            (block(length(block)-P+1:length(block))+newBlock(1:P))'... % Overlap Section
            newBlock(P+1:length(newBlock))']'; % Ending Section
    end
    plot(abs(block));
    pause
end

% Take the Inverse FFT & Remove Last P Samples
xblock = ifft(block);
xblock = xblock(1:length(xblock)-P);  
conv(impResponse,noisySig);


