function [sig] = SinGenerator(numSamples, bits)
%{
    *****************************************************
    Description: This function will calculate a sine wave
        vector using the specified inputs

    numSamples: Length of the vector you want to receive
    bits: Bit Depth of the sine wave
    *****************************************************
%}

phase = 0:2*pi/numSamples:2*pi;
sig = round(sin(phase) * 2^(bits-1)-1);
sig = sig(1:end-1);

end