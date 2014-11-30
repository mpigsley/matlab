function [ scrambled_sig ] = scrambler( original, normalize_foldover )

section_samples = floor(length(original)/length(normalize_foldover));
scrambled_sig = 0;

for len=1:length(normalize_foldover)
    if len == 1
        op_section = original(1:len*section_samples);
    else
        op_section = original((len-1)*section_samples+1:len*section_samples);
    end
    
    %{
    Get all Positive Features
        - fft
        - Hilbert Transform of Original Signal
    %}
    original_spectrum = fft(op_section);
    ht_filter_high = [zeros(1,length(original_spectrum)/2) ones(1,length(original_spectrum)/2,1)]';
    original_pos_freqs = original_spectrum.*ht_filter_high;
    original_pos_freqs = original_pos_freqs((length(original_pos_freqs)/2)+1:end);

    %{
    Frequency Shift Down
        - Foldover Frequency Positioned at 0 Hz
    %}
    foldover_len = floor((length(original_spectrum)- normalize_foldover(len)*length(original_spectrum))/2);
    shifted_spectrum = [zeros(1,foldover_len) original_pos_freqs']';
    shifted_spectrum = [shifted_spectrum' zeros(1,length(original_spectrum)-length(shifted_spectrum))+1]';
    
    %{
    Split Spectrum
        - Two Signals Created by Two Hilbert Transforms
        1) Content Below Foldover (Negative Frequencies)
        2) Content Above Foldover (Positive Frequencies)
    %}
    ht_filter_low = [ones(1,length(original_spectrum)/2) zeros(1,length(original_spectrum)/2,1)]';
    high_foldover = shifted_spectrum.* ht_filter_high;
    low_foldover = shifted_spectrum.* ht_filter_low;

    %{
    Frequency Shift Negative Up
        - Take Negative Frequencies and Shift Up Avove Positive Frequencies
        - Combine Signals
        - IFFT
        - Take Real Part of Combined Signals
    %}
    shifted_low_foldover = [zeros(1,length(shifted_spectrum)/2) low_foldover']';
    shifted_low_foldover = shifted_low_foldover(1:length(original_spectrum));
    scrambled_spectrum = high_foldover + shifted_low_foldover;
    scrambled_sig_section = real(ifft(scrambled_spectrum));
    scrambled_sig = [scrambled_sig' scrambled_sig_section']';
end

    scrambled_sig = scrambled_sig(2:end);
end

